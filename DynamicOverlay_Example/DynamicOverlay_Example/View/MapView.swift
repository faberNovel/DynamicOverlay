//
//  MapView.swift
//  DynamicOverlay_Example
//
//  Created by Gaétan Zanella on 17/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: View {

    var body: some View {
        MapViewAdaptor().ignoresSafeArea()
    }
}

private struct MapViewAdaptor: UIViewRepresentable {

    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}
}
