//
//  SearchBar.swift
//  DynamicOverlay_Example
//
//  Created by Gaétan Zanella on 18/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct SearchBar: View {

    enum Event {
        case didBeginEditing
        case didCancel
    }

    let eventHandler: (Event) -> Void

    var body: some View {
        SearchBarAdaptator(
            didBeginEditing: { eventHandler(.didBeginEditing) },
            didCancel: { eventHandler(.didCancel) }
        )
    }
}

private class SearchBarCoordinator: NSObject, UISearchBarDelegate {

    var didBeginEditing: (() -> Void)?
    var didCancel: (() -> Void)?

    // MARK: - UISearchBarDelegate

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        didBeginEditing?()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        didCancel?()
    }
}

private struct SearchBarAdaptator: UIViewRepresentable {

    let didBeginEditing: () -> Void
    let didCancel: () -> Void

    func makeCoordinator() -> SearchBarCoordinator {
        let coordinator = SearchBarCoordinator()
        coordinator.didBeginEditing = didBeginEditing
        coordinator.didCancel = didCancel
        return coordinator
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search for a place or address"
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {}
}
