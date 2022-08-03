//
//  DisplayChartView.swift
//  DataViewer
//
//  Created by Labtanza on 7/31/22.
//

import SwiftUI
import Charts


struct DisplayView: View {
    @EnvironmentObject var dataService:DataManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Reccomended Curve").font(.title2)
            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20) {
                GridRow(alignment: .firstTextBaseline) {
                    Text("Curve Fit:")
                    Text("\(dataService.curveFitMessage)")
                }
                
                GridRow(alignment: .firstTextBaseline) {
                    Text("Error Analysis:")
                    Text("\(dataService.errorAnalysisMessage)")
                }
            }
            

            Chart {
                if dataService.hasNudge {
                    ForEach(dataService.setForFunc(dataService.nudgeFunction), id: \.x) { point in
                        
                        LineMark(
                            x: .value("X", point.x),
                            y: .value("Y", point.y)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.purple)
                    }
                }
            
                
                ForEach(dataService.data, id: \.x) { point in
                    
                    LineMark(
                        x: .value("X", point.x),
                        y: .value("Y", dataService.fitFuntion(point.x))
                    )
                    .foregroundStyle(.orange)
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("X", point.x),
                        y: .value("Y", point.y)
                    )
                }
                

            }
            .aspectRatio(1, contentMode: .fit)

            Text("Custom Curve").font(.title2)
            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20) {
                GridRow(alignment: .firstTextBaseline) {
                    Text("Error Analysis:")
                    Text("\(dataService.nudgedErrorAnalysisMessage)")
                }
            }
        }.padding(5)
    }
    
}

struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView().environmentObject(DataManager())
    }
}
