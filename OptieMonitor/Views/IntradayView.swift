//
//  QuotesView.swift
//  OMSwiftUI
//
//  Created by André Hartman on 01/07/2020.
//  Copyright © 2020 André Hartman. All rights reserved.
//
import SwiftUI

struct IntradayView: View {
    @Bindable var viewModel: ViewModel
    @State private var showGraphSheet = false
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        NavigationView {
            List {
                Section(
                    header: HeaderView(),
                    footer: FooterView(footerLines: viewModel.intraday.footer)
                ) { ForEach(viewModel.intraday.list, id: \.id) {
                    line in
                    RowView(line: line)
                }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.defaultMinListRowHeight, 10)
            .navigationBarTitle("Intraday (\(UIApplication.appVersion!))", displayMode: .inline)
            .navigationBarItems(
                leading:
                Button(action: { showGraphSheet.toggle() })
                    { Image(systemName: "chart.bar") },
                trailing:
                Button(action: { Task {
                    await viewModel.getJsonData(action: "cleanOrder")
                }})
                    { Image(systemName: "arrow.clockwise") }
            )
            .refreshable {
                await viewModel.getJsonData(action: "currentOrder")
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                Task {
                    print("from IntradayView")
                    await viewModel.getJsonData(action: "currentOrder")
                }
            } else {
                print("ScenePhase: \(phase)")
            }
        }
        .alert(isPresented: $viewModel.isMessage) {
            Alert(title: Text("AEX"),
                  message: Text(viewModel.message ?? ""),
                  dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showGraphSheet) {
            IntraGraphView()
        }
    }
}

/*
 struct IntradayView_Previews: PreviewProvider {
 static let viewModel = ViewModel()
 static var previews: some View {
 IntradayView().environmentObject(viewModel)
 }
 }
 */
