//
//  DisplayChartView.swift
//  DataViewer
//
//  Created by Labtanza on 7/31/22.
//

import SwiftUI
import Charts
import DataHelper

extension FitStrategy:PickerSuppliable {
    var menuText: String {
        self.description
    }
}


struct DisplayView: View {
    @EnvironmentObject var dataService:DataManager
    
    var body: some View {
        VStack {

            Chart(dataService.data) { point in
                LineMark(
                    x: .value("X", point.x),
                    y: .value("Y", dataService.functionGuess(point.x))
                )
                .interpolationMethod(.catmullRom)
                PointMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y)
                )
            }
            .aspectRatio(1, contentMode: .fit)
            HStack {
                VStack {
                    EnumPicker<FitStrategy>(value: $dataService.curve)
                    Text("\(dataService.curveFitMessage)")
                    Button("Update Fit", action: dataService.updateCurveFit)
                }
                VStack {
                    Text("\(dataService.errorAnalysisMessage)")
                    Button("Update Error Analysis", action: dataService.updateErrorAnalysis)
                }
            }
            
        }
    }
}

struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView().environmentObject(DataManager())
    }
}
