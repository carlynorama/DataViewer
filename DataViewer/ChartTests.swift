////
////  ChartTests.swift
////  DataViewer
////
////  Created by Labtanza on 8/3/22.
////
//
//
//extension Date {
//    static func random(in range: Range<Date>) -> Date {
//        Date(
//            timeIntervalSinceNow: .random(
//                in: range.lowerBound.timeIntervalSinceNow...range.upperBound.timeIntervalSinceNow
//            )
//        )
//    }
//}
//
//import SwiftUI
//import Charts
//
//struct ChartTests: View {
//    struct ProfitOverTime {
//        var date: Date
//        var profit: Double
//    }
//
//    static func dataBuilder() {
//        var days:[Date] = []
//        var dateComponets =
//        let year = Calendar.current.component(.year, from: Date())
//        for i in 1...12 {
//            let date = Date.
//        }
//    }
//    
//    let departmentAProfit: [ProfitOverTime] = [] // ...
//    let departmentBProfit: [ProfitOverTime] = [] // ...
//
//    var body: some View {
//        Chart {
//            ForEach(departmentAProfit) {
//                LineMark(
//                    x: .value("Date", $0.date),
//                    y: .value("Profit A", $0.profit)
//                )
//                .foregroundStyle(.blue)
//            }
//            ForEach(departmentBProfit) {
//                LineMark(
//                    x: .value("Date", $0.date),
//                    y: .value("Profit B", $0.profit)
//                )
//                .foregroundStyle(.green)
//            }
//            RuleMark(
//                y: .value("Threshold", 500.0)
//            )
//            .foregroundStyle(.red)
//        }
//    }
//}
//
//struct ChartTests_Previews: PreviewProvider {
//    static var previews: some View {
//        ChartTests()
//    }
//}
