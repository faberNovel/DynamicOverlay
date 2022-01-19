//
//  SwitchDrivingScrollViewsTest.swift
//  DynamicOverlay_Example
//
//  Created by Lukas Hansen on 03.01.22.
//  Copyright © 2022 Fabernovel. All rights reserved.
//

import DynamicOverlay
import SwiftUI

extension MultipleScrollViewsDrivingScrollView {
    enum Notch: CaseIterable, Equatable {
        case min
        case max
    }
}

struct MultipleScrollViewsDrivingScrollView: View {
    @State var notch: Notch = .max
    @State var scrollViewDriving = true
    @State var contentSwapped = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.red // map
                    .ignoresSafeArea()
                Color.green // something else
                    .ignoresSafeArea(.all, edges: .bottom)
                    .navigationTitle("Test")
                    .navigationBarHidden(true)
                    .dynamicOverlay(overlayView)
                    .dynamicOverlayBehavior(behavior)
                    .ignoresSafeArea(.all, edges: .bottom)
            }
        }
    }

    private var behavior: some DynamicOverlayBehavior {
        MagneticNotchOverlayBehavior<Notch> { notch in
            switch notch {
            case .min:
                return .fractional(0.3)
            case .max:
                return .fractional(0.9)
            }
        }.notchChange($notch)
    }

    var overlayView: some View {
        VStack {
            header
            Button {
                contentSwapped.toggle()
            } label: {
                Text("Content swap")
            }
            list1
            if contentSwapped {
                list3
                    .accessibilityIdentifier("List3")
                    .drivingScrollView(scrollViewDriving)
            } else {
                list2
                    .accessibilityIdentifier("List2")
                    .drivingScrollView(scrollViewDriving)
            }
        }.background(Color.white)
            .foregroundColor(Color.black)
            .frame(maxWidth: .infinity)
    }

    var header: some View {
        HStack {
            Text("An header. ScrollViewDriving: \(String(scrollViewDriving))")
                .font(.largeTitle.bold())
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            scrollViewDriving.toggle()
        }
    }

    var list1: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<100) { index in
                    Text("Some text: \(index)")
                }
            }
        }
    }

    var list2: some View {
        ScrollView {
            VStack {
                ForEach(0..<100) { index in
                    Text("Another type of text: \(index)")
                }
            }
        }
        .background(Color.red)
        .foregroundColor(Color.blue)
    }

    var list3: some View {
        ScrollView {
            VStack {
                ForEach(0..<100) { index in
                    Text("THE text: \(index)")
                }
            }
        }
        .background(Color.red)
        .foregroundColor(Color.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleScrollViewsDrivingScrollView()
    }
}
