//
//  OverlayView.swift
//  DynamicOverlay_Example
//
//  Created by Gaétan Zanella on 17/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import SwiftUI
import DynamicOverlay

struct OverlayView: View {

    enum Event {
        case didBeginEditing
        case didEndEditing
    }

    let eventHandler: (Event) -> Void

    // MARK: - View

    var body: some View {
        VStack(spacing: 0.0) {
            header.draggable()
            list
        }
        .background(OverlayBackgroundView())
    }

    // MARK: - Private

    private var list: some View {
        List {
            Section(header: Text("Favorites")) {
                ScrollView(.horizontal) {
                    HStack {
                        FavoriteCell(imageName: "house.fill", title: "House")
                        FavoriteCell(imageName: "briefcase.fill", title: "Work")
                        FavoriteCell(imageName: "plus", title: "Add")
                    }
                }
            }
            Section(header: Text("My Guides")) {
                ActionCell()
            }
        }
        .listStyle(GroupedListStyle())
    }

    private var header: some View {
        SearchBar { event in
            switch event {
            case .didBeginEditing:
                eventHandler(.didBeginEditing)
            case .didCancel:
                eventHandler(.didEndEditing)
            }
        }
    }
}
