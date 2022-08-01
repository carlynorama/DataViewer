//
//  DataService.swift
//  DataViewer
//
//  Created by Labtanza on 7/31/22.
//

import Foundation
import SwiftUI
import DataHelper


final class DataManager: ObservableObject {
    @Published private(set) var data:[DataPoint] = []
    
    @Published var inputText = ""
    @Published var datatext: String?
    
    @Published private(set) var hasData:Bool = false
    
    //MARK: Loading Data
    @Published private(set) var testData = DataHelper.generateTestData(using: DataHelper.testInverseSquare, for: DataHelper.testValues).sortedByX()
    
    //TODO: Throw
    func updateData(withText text:String) {
        let dataHopper:[DataPoint] = DataParser().parseData(from: text, withStrategy: .arrayPrint)
        data = dataHopper.sortedByX()
        hasData = !data.isEmpty
    }
    
    //Fitting Data
    let functionGuess = DataHelper.testInverseSquare//DataHelper.testQuadraticFunction
    @Published var curve:FitStrategy = .linear

    func updateReport() {
        message = runReport(on: data, using: functionGuess)
    }
    func runReport(on data:[DataPoint], using function:(Number)->Number) -> String {
        return DataHelper.testFit(data, to:function).description
    }
    

    
    //MARK: Display Text
    @Published private(set) var message = "No Fit Report Available"
    
    var minX:String {
        testData.minXPoint()?.description ?? "None Found"
    }
    
    var maxX:String {
        testData.maxXPoint()?.description ?? "None Found"
    }
    
    var minY:String {
        testData.minYPoint()?.description ?? "None Found"
    }
    
    var maxY:String {
        testData.maxYPoint()?.description ?? "None Found"
    }
    
    var myResult:String {
        //let result = DataHelper.solveLinearPair(cx1: 2, cy1: 4, s1: 2, cx2: -4, cy2: 2, s2: 14)
        let result = DataHelper.tryFit(for: data, using: curve)
        return "\(result.description)"
    }

    
    //MARK: Collecting Data From The User
    func paste() {
        if UIPasteboard.general.hasStrings {
            let pasteboard = UIPasteboard.general
            inputText = pasteboard.string ?? inputText
        }
    }
    
    
}
