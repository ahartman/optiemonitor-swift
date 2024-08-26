//
//  InterdayView.swift
//  OMSwiftUI
//
//  Created by André Hartman on 05/07/2020.
//  Copyright © 2020 André Hartman. All rights reserved.
//
import SwiftUI

struct InterdayView: View {
    @Environment(ViewModel.self) private var viewModel
    @State var showGraphView = false

    var body: some View {
        GeometryReader { geo in
            NavigationView {
                List {
                    Section(header: HeaderView(geo: geo.size),
                            footer: FooterView(geo: geo.size, footerLines: viewModel.interday.footer))
                    {
                        ForEach(viewModel.interday.list) { line in
                            RowView(geo: geo.size, line: line)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.defaultMinListRowHeight, 10)
                .navigationBarTitle("Interday", displayMode: .inline)
                .navigationBarItems(
                    leading:
                    Button(action: { showGraphView.toggle() })
                        { Image(systemName: "chart.bar") }
                )
            }
            .sheet(isPresented: $showGraphView) {
                InterGraphView()
            }
        }
    }
}
