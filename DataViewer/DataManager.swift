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
//    struct MyDataType:DataPoint,Identifiable {
//        var x: Number
//
//        var y: Number
//
//        var point:(x: Number, y: Number) {
//            (x,y)
//        }
//
//        var id = UUID()
//
//    }
    
    @Published private(set) var data:[DataPoint] = []
    
    @Published var inputText = ""
    @Published var datatext: String?
    
    @Published private(set) var hasData:Bool = false
    
    //MARK: Loading Data
    //@Published private(set) var testData = DataHelper.generateTestData(using: DataHelper.testInverseSquare, for: DataHelper.testValues).sortedByX()
    
    @Published var parseStrategy:DataParser.ParseStrategy = .arrayPrint
    
    //TODO: Throw
    func updateData(withText text:String) {
        let dataHopper:[DataPoint] = DataParser().parseData(from: text, withStrategy: parseStrategy)
        data = dataHopper.sortedByX()//.map { MyDataType(x: $0.x, y: $0.y) }
        print(data)
        if data.count >= 1 {
            hasData = !data.isEmpty
        }
        
        if data.count >= 2 {
            updateCurveFit()
            updateErrorAnalysis()
        }

    }
    
    //MARK: Fitting Data
    @Published var fitFuntion = DataHelper.generateFunction(using: CurveProfile.linear, with: ["m":2, "b":4])
    @Published var curve:CurveProfile = .linear
    @Published var fitResult:(description:String, values:Dictionary<String, Number>) = ("starting fit 2x+4", ["m":2, "b":4])
    
    func updateCurveFit() {
        fitResult = DataHelper.tryFit(for: data, using: curve)
        curveFitMessage = fitResult.description
        //print("updateCurveFit: try fit result \(fitResult)")
        fitFuntion = DataHelper.generateFunction(using: curve, with: fitResult.values)
        updateErrorAnalysis()
    }

    func updateErrorAnalysis() {
        errorAnalysisMessage = runErrorAnalysis(on: data, using: fitFuntion)
        if hasNudge {
            nudgedErrorAnalysisMessage = runErrorAnalysis(on: data, using: nudgeFunction)
        }
    }
    
    private func runErrorAnalysis(on data:[DataPoint], using function:(Number)->Number) -> String {
        return DataHelper.testFit(data, to:function).description
    }
    
    //MARK: Nudged Fit Curve
    @Published var nudgedFunctionCurve:CurveProfile = .linear
    @Published var nudgedFunctionParameters:[Number] = [2, 4]
    @Published var hasNudge:Bool = false
                                                
    var nudgeFunction:(Number)->(Number) {
        DataHelper.generateFunction(using: nudgedFunctionCurve, parameterValues: nudgedFunctionParameters)
    }
    
    func updateNundgedWithFit() {
        nudgedFunctionCurve = curve
        nudgedFunctionParameters = CurveProfile.extractParameterValues(parameters: fitResult.values)
        hasNudge = true
    }
    
    
    
    //MARK: Display Text
    @Published private(set) var errorAnalysisMessage = "No Error Analysis Available"
    @Published private(set) var curveFitMessage = "No Curve Fit Results Available"
    
    @Published private(set) var nudgedErrorAnalysisMessage = "No Error Analysis Available"
    
//    var minX:String {
//        data.minXPoint()?.description ?? "None Found"
//    }
//    
//    var maxX:String {
//        data.maxXPoint()?.description ?? "None Found"
//    }
//    
//    var minY:String {
//        data.minYPoint()?.description ?? "None Found"
//    }
//    
//    var maxY:String {
//        data.maxYPoint()?.description ?? "None Found"
//    }

    
//    //MARK: Collecting Data From The User
//    func paste() {
//        if UIPasteboard.general.hasStrings {
//            let pasteboard = UIPasteboard.general
//            inputText = pasteboard.string ?? inputText
//        }
//    }
//
    
}
