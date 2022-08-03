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
    
    let storage = UserDefaults.standard
    
    let datasStringKey = "lastText"
    let parseStrategyKey = "parseStrategy"
    
    let fitStrategyKey = "fitStrategy"
    let nudgeStrategyKey = "nudgeStrategy"
    let nudgeValuesKey = "nudgeValues"
    
    
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
        
        storage.set(text, forKey: datasStringKey)
    }
    
    func loadStoredData() {
        let _ = loadStoredDataWithConfirmation()
    }
    
    func loadStoredDataWithConfirmation() -> Bool {
        if let storedDataString = storage.object(forKey: datasStringKey) as? String {
            updateData(withText: storedDataString)
            datatext = storedDataString
            return true
        }
        return false
    }
    
    func loadCurveForKey(_ string:String) -> CurveProfile? {
        if let storedString = storage.string(forKey: string)  {
            if let savedStrategy = CurveProfile(rawValue: storedString) {
                return savedStrategy
            }
        }
        return nil
    }
    
    func loadSettings() {
        if let storedString = storage.string(forKey: parseStrategyKey)  {
            if let savedStrategy = DataParser.ParseStrategy(rawValue: storedString) {
                parseStrategy = savedStrategy
            }
        }
        
        if let storedFitStrategy = loadCurveForKey(fitStrategyKey) {
            fitCurve = storedFitStrategy
        }
        
        if let storedNudgeStrategy = loadCurveForKey(nudgeStrategyKey) {
            nudgedFunctionCurve = storedNudgeStrategy
        }
        
        
        if let storedNudgeValues = storage.object(forKey: nudgeValuesKey) as? [Number] {
           nudgedFunctionParameters = storedNudgeValues
        }
    }
    
    func saveSettings() {
        storage.set(parseStrategy.rawValue, forKey: parseStrategyKey)
        storage.set(fitCurve.rawValue, forKey: fitStrategyKey)
        storage.set(nudgedFunctionCurve.rawValue, forKey: nudgeStrategyKey)
        storage.set(nudgedFunctionParameters,forKey: nudgeValuesKey)
        print("DataViewer.saveSettings")
    }
    
    func clearData() {
        data = []
        storage.removeObject(forKey: datasStringKey)
        datatext = ""
        inputText = ""
        hasData = false
    }
    
    //MARK: Fitting Data
    @Published var fitFuntion = DataHelper.generateFunction(using: CurveProfile.linear, with: ["m":2, "b":4])
    @Published var fitCurve:CurveProfile = .linear {
        didSet {
            updateCurveFit()
        }
    }
    @Published var fitResult:(description:String, values:Dictionary<String, Number>) = ("starting fit 2x+4", ["m":2, "b":4])
    
    func updateCurveFit() {
        fitResult = DataHelper.tryFit(for: data, using: fitCurve)
        curveFitMessage = fitResult.description
        //print("updateCurveFit: try fit result \(fitResult)")
        fitFuntion = DataHelper.generateFunction(using: fitCurve, with: fitResult.values)
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
    @Published var nudgedFunctionCurve:CurveProfile = .linear {
        didSet {
            hasNudge = true
            if nudgedFunctionCurve == .quadratic && nudgedFunctionParameters.count < 3 {
                nudgedFunctionParameters.append(0)
            }
        }
    }
    @Published var nudgedFunctionParameters:[Number] = [2, 4]
    @Published var hasNudge:Bool = false
                                                
    var nudgeFunction:(Number)->(Number) {
        return DataHelper.generateFunction(using: nudgedFunctionCurve, parameterValues: nudgedFunctionParameters)
    }
    
    func updateNundgedWithFit() {
        nudgedFunctionCurve = fitCurve
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
