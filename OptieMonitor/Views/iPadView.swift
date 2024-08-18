//
//  iPadView.swift
//  OptieMonitor
//
//  Created by André Hartman on 18/08/2024.
//

import SwiftUI

struct iPadView: View {
    @Bindable var viewModel: ViewModel

    var body: some View {
        VStack {
            HStack {
                List {
                    Section(
                        header: HeaderView(),
                        footer: FooterView(footerLines: viewModel.intraday.footer))
                    {
                        ForEach(viewModel.intraday.list, id: \.id) {
                            line in
                            RowView(line: line)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.defaultMinListRowHeight, 10)
                List {
                    Section(header: HeaderView(),
                            footer: FooterView(footerLines: viewModel.interday.footer))
                    {
                        ForEach(viewModel.interday.list, id: \.id) { line in
                            RowView(line: line)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.defaultMinListRowHeight, 10)
            }
            HStack {
                IntraChartView()
                InterChartView()
            }
        }
    }
}
