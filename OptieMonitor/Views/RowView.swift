//
//  InterdayRowView.swift
//  OMSwiftUI
//
//  Created by André Hartman on 06/07/2020.
//  Copyright © 2020 André Hartman. All rights reserved.
//
import SwiftUI

struct RowView: View {
    @Environment(\.verticalSizeClass) var sizeClass
    var geo = CGSize()
    var line: TableLine

    var body: some View {
        HStack(spacing: 0) {
            Text(line.datetimeText)
                .modifier(TextModifier())
            Text(line.callPriceText)
                .modifier(TextModifier())
            if geo.height < geo.width  {
                Text(line.callDeltaText)
                    .modifier(TextModifier())
                    .foregroundColor(Color(line.callDeltaColor))
            }
            Text(line.putPriceText)
                .modifier(TextModifier())
            if geo.height < geo.width  {
                Text(line.putDeltaText)
                    .modifier(TextModifier())
                    .foregroundColor(Color(line.putDeltaColor))
            }
            Text(line.orderValueText)
                .modifier(TextModifier())
                .foregroundColor(Color(line.orderValueColor))
            Text(line.indexText)
                .modifier(TextModifier())
        }
    }
}
