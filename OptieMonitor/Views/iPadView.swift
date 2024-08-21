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
            Text("\(caption)")
                .modifier(StaleModifier(dataStale: viewModel.dataStale))
                .padding([.bottom,.top])
            Divider()
            HStack {
                List {
                    Section(
                        header: HeaderView(dataStale: viewModel.dataStale),
                        footer: FooterView(footerLines: viewModel.intraday.footer))
                    {
                        ForEach(viewModel.intraday.list, id: \.id) {
                            line in
                            RowView(line: line)
                        }
                    }
                }
                Divider()
                List {
                    Section(header: HeaderView(dataStale: viewModel.dataStale),
                            footer: FooterView(footerLines: viewModel.interday.footer))
                    {
                        ForEach(viewModel.interday.list, id: \.id) { line in
                            RowView(line: line)
                        }
                    }
                }
            }
            .environment(\.defaultMinListRowHeight, 10)
            Divider()
            HStack {
                IntraChartView()
                Divider()
                InterChartView()
            }
            .cornerRadius(10.0)
            .padding(20)
            .background(Color(.systemGroupedBackground))
        }
    }
}
