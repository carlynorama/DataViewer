//
//  DisplayChartView.swift
//  DataViewer
//
//  Created by Labtanza on 7/31/22.
//

import SwiftUI
import Charts

struct DisplayChartView: View {
    @EnvironmentObject var dataService:DataManager
    
    var body: some View {
        VStack {

            Chart(dataService.data, id: \.x) { point in
//                LineMark(
//                    x: .value("X", point.x),
//                    y: .value("Y", point.y)
//                )
//                .interpolationMethod(.catmullRom)
                PointMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y)
                )
            }
            .aspectRatio(1, contentMode: .fit)
            Group {
                Text("\(dataService.message)")
                Button("Update Guess", action: dataService.updateReport)
                Text("Solve: \(dataService.myResult)")
            }
            
        }
    }
}

struct DisplayChartView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayChartView().environmentObject(DataManager())
    }
}
