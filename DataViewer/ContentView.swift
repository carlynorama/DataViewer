//
//  ContentView.swift
//  DataViewer
//
//  Created by Labtanza on 7/31/22.
//

import SwiftUI
import Charts


struct ContentView: View {
    @StateObject private var dataService = DataManager()
    
    var body: some View {
        HStack {
            DataEntryView().frame(maxWidth:.greatestFiniteMagnitude)
            
            if dataService.hasData {
                DisplayChartView().frame(maxWidth:.infinity)
            } else {
                Text("No valid data avaliable.").frame(maxWidth:.infinity)
            }
        }.environmentObject(dataService)
           
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
