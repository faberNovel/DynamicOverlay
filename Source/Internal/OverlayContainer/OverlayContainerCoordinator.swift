//
//  OverlayContainerCoordinator.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 02/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import UIKit
import SwiftUI
import OverlayContainer

struct OverlayContainerLayout: Equatable {
    let indexToDimension: [Int: NotchDimension]
}

// (gz) 2022-01-30 `SwiftUI` compares struct properties one by one to determine either to update the view or not.
// To avoid useless updates, we wrap the passive values inside this class.
class OverlayContainerPassiveContainer: Equatable {

    var onTranslation: ((OverlayTranslation) -> Void)?
    var onNotchChange: ((Int) -> Void)?

    static func == (lhs: OverlayContainerPassiveContainer, rhs: OverlayContainerPassiveContainer) -> Bool {
        lhs === rhs
    }
}

struct OverlayContainerState: Equatable {
    let dragArea: DynamicOverlayDragArea
    let drivingScrollViewProxy: DynamicOverlayScrollViewProxy
    let notchIndex: Int?
    let disabledNotches: Set<Int>
    let layout: OverlayContainerLayout
}

class OverlayContainerCoordinator {

    private let background: UIViewController
    private let content: UIViewController

    private let indexMapper = OverlayNotchIndexMapper()

    typealias State = OverlayContainerState

    private var state: State
    private let style: OverlayContainerViewController.OverlayStyle
    private let passiveContainer: OverlayContainerPassiveContainer

    private var animationController: DynamicOverlayContainerAnimationController {
        DynamicOverlayContainerAnimationController(style: style)
    }

    // MARK: - Life Cycle

    init(style: OverlayContainerViewController.OverlayStyle,
         layout: OverlayContainerLayout,
         passiveContainer: OverlayContainerPassiveContainer,
         background: UIViewController,
         content: UIViewController) {
        self.state = .initial(layout)
        self.passiveContainer = passiveContainer
        self.background = background
        self.content = content
        self.style = style
    }

    // MARK: - Public

    func move(_ container: OverlayContainerViewController, to state: State, animated: Bool) {
        if container.viewControllers.isEmpty {
            container.viewControllers = [background, content]
        }
        let changes = OverlayContainerStateDiffer().diff(
            from: self.state,
            to: state
        )
        let requiresLayoutUpdate = changes.contains(.index) || changes.contains(.layout)
        if requiresLayoutUpdate && animated {
            // we update the content first
            container.drivingScrollView = nil // issue #21
            container.view.layoutIfNeeded()
        }
        if changes.contains(.layout) {
            container.invalidateNotchHeights()
        }
        if let index = state.notchIndex, changes.contains(.index) {
            container.moveOverlay(toNotchAt: index, animated: animated)
        }
        if changes.contains(.scrollView) {
            CATransaction.setCompletionBlock { [weak container] in
                guard let overlay = container?.topViewController?.view else { return }
                container?.drivingScrollView = state.drivingScrollViewProxy.findScrollView(in: overlay)
            }
        }
        self.state = state
        if changes.contains(.layout) && !animated {
            UIView.performWithoutAnimation {
                container.view.layoutIfNeeded()
            }
        }
    }
}

extension OverlayContainerCoordinator: OverlayContainerViewControllerDelegate {

    // MARK: - OverlayContainerViewControllerDelegate

    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        indexMapper.reload(
            layout: state.layout,
            availableHeight: containerViewController.availableSpace
        )
        return indexMapper.numberOfOverlayIndexes()
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        heightForNotchAt index: Int,
                                        availableSpace: CGFloat) -> CGFloat {
        indexMapper.height(forOverlayIndex: index)
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        didMoveOverlay overlayViewController: UIViewController,
                                        toNotchAt index: Int) {
        let newState = state.withNewNotch(index)
        guard newState != state else { return }
        passiveContainer.onNotchChange?(indexMapper.dynamicIndex(forOverlayIndex: index))
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        willTranslateOverlay overlayViewController: UIViewController,
                                        transitionCoordinator: OverlayContainerTransitionCoordinator) {
        let animation = animationController.animation(using: transitionCoordinator)
        let transaction = Transaction(animation: animation)
        let translation = OverlayTranslation(
            height: transitionCoordinator.targetTranslationHeight,
            transaction: transaction,
            isDragging: transitionCoordinator.isDragging,
            translationProgress: transitionCoordinator.overallTranslationProgress(),
            containerFrame: containerViewController.view.frame,
            velocity: transitionCoordinator.velocity,
            heightForNotchIndex: { transitionCoordinator.height(forNotchAt: $0) }
        )
        withTransaction(transaction) { [weak passiveContainer] in
            passiveContainer?.onTranslation?(translation)
        }
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        canReachNotchAt index: Int,
                                        forOverlay overlayViewController: UIViewController) -> Bool {
        !state.disabledNotches.map { indexMapper.overlayIndex(forDynamicIndex: $0) }.contains(index)
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        shouldStartDraggingOverlay overlayViewController: UIViewController,
                                        at point: CGPoint,
                                        in coordinateSpace: UICoordinateSpace) -> Bool {
        guard let overlay = containerViewController.topViewController else { return false }
        let inOverlayPoint = overlay.view.convert(point, from: coordinateSpace)
        if state.dragArea.isEmpty {
            return overlay.view.frame.contains(inOverlayPoint)
        }
        return state.dragArea.contains(inOverlayPoint)
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        transitioningDelegateForOverlay overlayViewController: UIViewController) -> OverlayTransitioningDelegate? {
        self
    }
}

extension OverlayContainerCoordinator: OverlayTransitioningDelegate {

    // MARK: - OverlayTransitioningDelegate

    func animationController(for overlayViewController: UIViewController) -> OverlayAnimatedTransitioning? {
        animationController
    }
}

private extension OverlayContainerState {

    static func initial(_ layout: OverlayContainerLayout) -> OverlayContainerState {
        OverlayContainerState(
            dragArea: .default,
            drivingScrollViewProxy: .default,
            notchIndex: nil,
            disabledNotches: [],
            layout: layout
        )
    }

    func withNewNotch(_ notch: Int) -> OverlayContainerState {
        OverlayContainerState(
            dragArea: dragArea,
            drivingScrollViewProxy: drivingScrollViewProxy,
            notchIndex: notch,
            disabledNotches: disabledNotches,
            layout: layout
        )
    }
}
