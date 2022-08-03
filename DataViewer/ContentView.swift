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
                DisplayView().frame(maxWidth:.infinity)
            } else {
                Text("No valid data avaliable.").frame(maxWidth:.infinity)
            }
        }.environmentObject(dataService)
            .onAppear(perform: dataService.loadStoredData)
//            .onAppear(perform: dataService.loadSettings)
//            .onDisappear(perform: dataService.saveSettings)
           
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
