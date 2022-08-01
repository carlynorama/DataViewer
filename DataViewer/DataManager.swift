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
    //@Published private(set) var testData = DataHelper.generateTestData(using: DataHelper.testInverseSquare, for: DataHelper.testValues).sortedByX()
    
    //TODO: Throw
    func updateData(withText text:String) {
        let dataHopper:[DataPoint] = DataParser().parseData(from: text, withStrategy: .arrayPrint)
        data = dataHopper.sortedByX()
        hasData = !data.isEmpty
    }
    
    //Fitting Data
    var functionGuess = DataHelper.generateFunction(using: FitStrategy.linear, with: ["m":2, "b":4])
    @Published var curve:FitStrategy = .linear
    
    func updateCurveFit() {
        let result = DataHelper.tryFit(for: data, using: curve)
        curveFitMessage = result.description
        let parameters = result.values
        functionGuess = DataHelper.generateFunction(using: curve, with: parameters)
    }

    func updateErrorAnalysis() {
        errorAnalysisMessage = runErrorAnalysis(on: data, using: functionGuess)
        
    }
    private func runErrorAnalysis(on data:[DataPoint], using function:(Number)->Number) -> String {
        return DataHelper.testFit(data, to:function).description
    }
    
    
    //MARK: Display Text
    @Published private(set) var errorAnalysisMessage = "No Error Analysis Available"
    @Published private(set) var curveFitMessage = "No Curve Fit Results Available"
    
    var minX:String {
        data.minXPoint()?.description ?? "None Found"
    }
    
    var maxX:String {
        data.maxXPoint()?.description ?? "None Found"
    }
    
    var minY:String {
        data.minYPoint()?.description ?? "None Found"
    }
    
    var maxY:String {
        data.maxYPoint()?.description ?? "None Found"
    }

    
//    //MARK: Collecting Data From The User
//    func paste() {
//        if UIPasteboard.general.hasStrings {
//            let pasteboard = UIPasteboard.general
//            inputText = pasteboard.string ?? inputText
//        }
//    }
//
    
}
