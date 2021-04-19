//
//  FavoriteCell.swift
//  DynamicOverlay_Example
//
//  Created by Gaétan Zanella on 19/04/2021.
//  Copyright © 2021 Fabernovel. All rights reserved.
//

import Foundation
import SwiftUI

struct FavoriteCell: View {

    let imageName: String
    let title: String

    var body: some View {
        VStack {
            Circle()
                .foregroundColor(Color(.secondarySystemFill))
                .frame(width: 70, height: 70)
                .overlay(Image(systemName: imageName).font(.title2).foregroundColor(.blue))
            Text(title)
        }
    }
}
