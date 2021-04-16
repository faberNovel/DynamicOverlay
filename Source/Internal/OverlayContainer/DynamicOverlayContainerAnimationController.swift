//
//  DynamicOverlayContainerAnimationController.swift
//  DynamicOverlay
//
//  Created by Gaétan Zanella on 28/12/2020.
//  Copyright © 2020 Fabernovel. All rights reserved.
//

import UIKit
import SwiftUI
import OverlayContainer

private struct Constant {
    static let defaultMass: CGFloat = 1
    static let defaultDamping: CGFloat = 0.7
    static let defaultRigidDamping: CGFloat = 0.9
    static let defaultResponse: CGFloat = 0.3
    static let minimumDamping: CGFloat = 1
    static let minimumVelocityConsideration: CGFloat = 150
    static let maximumVelocityConsideration: CGFloat = 3000
}

struct DynamicOverlayContainerAnimationController: OverlayAnimatedTransitioning {

    private var mass: CGFloat = Constant.defaultMass
    private var damping: CGFloat = Constant.defaultDamping
    private var response: CGFloat = Constant.defaultResponse

    // MARK: - Public

    public func animation(using context: OverlayContainerTransitionCoordinatorContext) -> Animation? {
        guard context.isAnimated else { return nil }
        return .interpolatingSpring(
            mass: Double(springMass(context: context)),
            stiffness: Double(springStiffness(context: context)),
            damping: Double(springDamping(context: context)),
            initialVelocity: Double(springVelocity(context: context))
        )
    }

    // MARK: - OverlayAnimatedTransitioning

    public func interruptibleAnimator(using context: OverlayContainerContextTransitioning) -> UIViewImplicitlyAnimating {
        let timing = UISpringTimingParameters(
            mass: springMass(context: context),
            stiffness: springStiffness(context: context),
            damping: springDamping(context: context),
            initialVelocity: CGVector(dx: springVelocity(context: context), dy: springVelocity(context: context))
        )
        return UIViewPropertyAnimator(
            duration: 0, // duration is ignored when using `UISpringTimingParameters.init(mass:stiffness:damping:initialVelocity)`
            timingParameters: timing
        )
    }

    private func springMass(context: OverlayContainerTransitionContext) -> CGFloat {
        mass
    }

    private func springStiffness(context: OverlayContainerTransitionContext) -> CGFloat {
        pow(2 * .pi / response, 2)
    }

    private func springDamping(context: OverlayContainerTransitionContext) -> CGFloat {
        let velocity = min(
            Constant.maximumVelocityConsideration,
            max(abs(context.velocity.y), Constant.minimumVelocityConsideration)
        )
        let velocityRange = Constant.maximumVelocityConsideration - Constant.minimumVelocityConsideration
        let normalizedVelocity = (velocity - Constant.minimumVelocityConsideration) / velocityRange
        let normalizedDamping = normalizedVelocity * (damping - Constant.minimumDamping) + Constant.minimumDamping
        return 4 * .pi * normalizedDamping / response
    }

    private func springVelocity(context: OverlayContainerTransitionContext) -> CGFloat {
        0
    }
}
