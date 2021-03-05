//
//  ViewController.swift
//  DynamicOverlay_Example
//
//  Created by Gaétan Zanella on 05/03/2019.
//  Copyright © 2019 Fabernovel. All rights reserved.
//

import UIKit
import SwiftUI
import DynamicOverlay

class ViewController: UIHostingController<ContentView> {

    // MARK: - Life Cycle

    init() {
        super.init(rootView: ContentView())
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ContentView: View {

    var body: some View {
        
        OverlayContainerDynamicOverlayView(background: background, content: overlay.drivingScrollView())
            .dynamicOverlayBehavior(notchOverlayBehavior)
    }
    
    var background: some View {
        
        List {
            
            ForEach(0..<100) { number in
                
                Button(action: { print("background tap: \(number)") }) {
                    
                    HStack {
                        Text("\(number)")
                        Spacer()
                    }
                    .background(Color.red)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    var overlay: some View {
        
        ZStack {
                        
            List {
                
                ForEach(0..<100) { number in
                    
                    Button(action: { print("overlay tap: \(number)") }) {
                        HStack {
                            Text("\(number)")
                            Spacer()
                        }
                        .background(Color.green)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

enum Notch: CaseIterable, Equatable {
    case min
    case med
    case max
}

var notchOverlayBehavior: some DynamicOverlayBehavior {
    
    MagneticNotchOverlayBehavior<Notch> { notch in
        switch notch {
        case .max:
            return .fractional(0.8)
        case .med:
            return .fractional(0.5)
        case .min:
            return .fractional(0.3)
        }
    }
}
