//
//  FooterView.swift
//  OptieMonitor
//
//  Created by André Hartman on 04/06/2021.
//
import SwiftUI

struct FooterView: View {
    // footerLine is passed as argument as it can be intraFooter or interfooter
    var geo: CGSize
    var footerLines: [FooterLine]

    var body: some View {
        VStack {
            FooterRowView(footerLine: footerLines[0], geo: geo)
            if footerLines.count > 1 {
                Divider()
                FooterRowView(footerLine: footerLines[1], geo: geo)
            }
        }
    }
}

struct FooterRowView: View {
    @Environment(\.verticalSizeClass) var sizeClass
    var footerLine: FooterLine
    var geo: CGSize

    var body: some View {
        HStack {
            Text(footerLine.label).modifier(TextModifier())
            Text("\(footerLine.callPercent)").modifier(TextModifier())
            if geo.height < geo.width {
                Text("").modifier(TextModifier())
            }
            Text("\(footerLine.putPercent)").modifier(TextModifier())
            if geo.height < geo.width {
                Text("").modifier(TextModifier())
            }
            Text("\(footerLine.orderPercent)").modifier(TextModifier())
            Text("\(footerLine.index)").modifier(TextModifier())
        }
    }
}
