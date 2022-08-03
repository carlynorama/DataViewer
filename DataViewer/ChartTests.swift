//
//  ChartTests.swift
//  DataViewer
//
//  Created by Labtanza on 8/3/22.
//

import SwiftUI
import Charts

struct ChartTests: View {
    struct ProfitOverTime {
        var date: Date
        var profit: Double
    }

    static func months(forYear year:Int) -> [Date] {
        var days:[Date] = []
        var dateComponets = DateComponents()
        //let year = Calendar.current.component(.year, from: Date())
        dateComponets.year = year
        dateComponets.day = 1
        for i in 1...12 {
            dateComponets.month = i
            if let date = Calendar.current.date(from: dateComponets) {
                days.append(date)
            }
        }
        return days
    }
    
    static func dataBuilder(forYear year:Int) -> [ProfitOverTime]{
        var data:[ProfitOverTime] = []
        for month in months(forYear: year) {
            let new = ProfitOverTime(date: month, profit: Double.random(in: 200...600))
            data.append(new)
        }
        return data
    }
    
    let departmentAProfit: [ProfitOverTime] = Self.dataBuilder(forYear: 2021)
    let departmentBProfit: [ProfitOverTime] = Self.dataBuilder(forYear: 2021)

    var body: some View {
        Chart {
            ForEach(departmentAProfit, id: \.date) {
                LineMark(
                    x: .value("Date", $0.date),
                    y: .value("Profit A", $0.profit)
                )
                .foregroundStyle(.blue)
            }
            
            ForEach(departmentBProfit, id: \.date) {
                LineMark(
                    x: .value("Date", $0.date),
                    y: .value("Profit B", $0.profit)
                )
                .foregroundStyle(.green)
            }
            RuleMark(
                y: .value("Threshold", 500.0)
            )
            .foregroundStyle(.red)
        }
    }
}

struct ChartTests_Previews: PreviewProvider {
    static var previews: some View {
        ChartTests()
    }
}
