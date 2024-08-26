//
//  HeaderView.swift
//  OMSwiftUI
//
//  Created by André Hartman on 04/08/2020.
//  Copyright © 2020 André Hartman. All rights reserved.
//
import SwiftUI

struct HeaderView: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.verticalSizeClass) var sizeClass
    var geo: CGSize
    var dataStale: Bool = false

    var body: some View {
        VStack {
            if UIDevice.current.userInterfaceIdiom != .pad {
                Text("\(caption)")
                    .modifier(StaleModifier(dataStale: dataStale))
                    .padding(.bottom)
            }
            HStack {
                Text("\(quoteDatetimeText)")
                    .modifier(TextModifier())
                Text("Call")
                    .modifier(TextModifier())
                if geo.height < geo.width  {
                    Text("∂")
                        .modifier(TextModifier())
                }
                Text("Put")
                    .modifier(TextModifier())
                if geo.height < geo.width  {
                   Text("∂")
                        .modifier(TextModifier())
                }
                Text("€")
                    .modifier(TextModifier())
                Text("Index")
                    .modifier(TextModifier())
            }
        }
    }
}
