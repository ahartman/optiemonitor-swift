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
        GeometryReader { geo in
            VStack {
                HStack {
                    Button(action: {
                        Task { await viewModel.getJsonData(action: "cleanOrder") }
                    }) { Image(systemName: "arrow.clockwise") }
                        .frame(alignment: .leading)
                        .padding(.leading)
                        .foregroundColor(.black)
                   Text("\(caption)")
                        .modifier(StaleModifier(dataStale: viewModel.dataStale))
                        .frame(alignment: .center)
               }
                Divider()
                HStack {
                    List {
                        Section(
                            header: HeaderView(dataStale: viewModel.dataStale),
                            footer: FooterView(footerLines: viewModel.intraday.footer))
                        {
                            ForEach(viewModel.intraday.list, id: \.id) {
                                line in
                                RowView(line: line, geo: geo.size)
                            }
                        }
                    }
                    Divider()
                    List {
                        Section(header: HeaderView(dataStale: viewModel.dataStale),
                                footer: FooterView(footerLines: viewModel.interday.footer))
                        {
                            ForEach(viewModel.interday.list, id: \.id) { line in
                                RowView(line: line, geo: geo.size)
                            }
                        }
                    }
                }
                .environment(\.defaultMinListRowHeight, 10)
                Divider()
                HStack {
                    IntraChartView()
                        .cornerRadius(10.0)
                        .padding(16)
                        .background(Color(.systemGroupedBackground))
                    Divider()
                    InterChartView()
                        .cornerRadius(10.0)
                        .padding(16)
                        .background(Color(.systemGroupedBackground))
                }
            }
        }
    }
}
