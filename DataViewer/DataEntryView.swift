//
//  DataEntryView.swift
//  DataViewer
//
//  Created by Labtanza on 7/31/22.
//

import SwiftUI
import DataHelper

extension DataParser.ParseStrategy:PickerSuppliable {
    static var labelText: String = "Parse Strategy"
    var menuText: String {
        switch self {
            
        case .lineDelimited:
            return "Line Delimited"
        case .arrayPrint:
            return "Array of Tuples"
        }
    }
}

extension CurveProfile:PickerSuppliable {
    static var labelText: String = "Curve Type"
    var menuText: String {
        self.description
    }
}

struct DataEntryView: View {
    
    @EnvironmentObject var dataService:DataManager
    
    @State var dataField:String = ""
    @FocusState var dataFieldHasFocus:Bool
    
    @FocusState private var np1Focused: Bool
    @FocusState private var np2Focused: Bool
    @FocusState private var np3Focused: Bool
    
    @State var returnSubmit:Bool = true
    
    //@State var stride:Double = 0
    @State var p1:Double = 0.0
    @State var p2:Double = 0.0
    @State var p3:Double = 0.0
    
    var body: some View {
        NavigationStack {
            
            Form {
                
                Section {
                    VStack {
                        EnumPicker(value: $dataService.parseStrategy).pickerStyle(.segmented)
                        
                        Toggle("Return submit", isOn: $returnSubmit)
                        
                        
                        TextField("Datapoint entry", text: $dataField, prompt: Text("enter or paste your data here"), axis: .vertical).onSubmit {
                            if returnSubmit {
                                dataService.updateData(withText: dataField)
                            }
                            dataField.append("\n")
                            dataFieldHasFocus = true
                        }
                        .lineLimit(10...)
                        .font(.body.monospaced())
                        .focused($dataFieldHasFocus)
                    }
                    
                    Section {
                        
                        EnumPicker<CurveProfile>(label:"Fit Curve", value: $dataService.fitCurve)
                        //Button("Run Fit", action: dataService.updateCurveFit)
                        
                    }.opacity((dataService.data.count > 3) ? 1.0 : 0.5)
                    
                    Section {
                        Button("Load Fit Curve into Nudge Curve", action: dataService.updateNundgedWithFit)
                        Button("Clear Nudge Curve", action: dataService.clearNudge)
                        Group {
                            EnumPicker<CurveProfile>(label: "Nudge Curve", value: $dataService.nudgedFunctionCurve)
                            
                            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20) {
                                if dataService.nudgedFunctionParameters.count >= 1 {
                                    GridRow {
                                        Text("Paramter 1")
                                        TextField("Paramter 1", value: $dataService.nudgedFunctionParameters[0], format: .number)
                                            .focused($np1Focused)
                                            .onChange(of: np1Focused) { isFocused in
                                                if !isFocused {
                                                    dataService.saveSettings()
                                                    //print("1")
                                                }
                                            }
                                    }
                                    
                                }
                                if dataService.nudgedFunctionParameters.count >= 2 {
                                    GridRow {
                                        Text("Paramter 2")
                                        TextField("Paramter 2", value: $dataService.nudgedFunctionParameters[1], format: .number)
                                            .focused($np2Focused)
                                            .onChange(of: np2Focused) { isFocused in
                                                if !isFocused {
                                                    dataService.saveSettings()
                                                    //print("2")
                                                }
                                            }
                                    }
                                    
                                }
                                if dataService.nudgedFunctionParameters.count >= 3 {
                                    GridRow {
                                        Text("Paramter 3")
                                        TextField("Paramter 3", value: $dataService.nudgedFunctionParameters[2], format: .number)
                                            .focused($np3Focused)
                                            .onChange(of: np3Focused) { isFocused in
                                                if !isFocused {
                                                    dataService.saveSettings()
                                                    //print("3")
                                                }
                                            }
                                    }
                                }
                            }
                        }.opacity((dataService.hasNudge) ? 1.0 : 0.5)
                    }.opacity((dataService.data.count > 3) ? 1.0 : 0.5)
                    Section {
                        Button("Run Error Analysis", action: dataService.updateErrorAnalysis)
                    }.opacity((dataService.data.count > 3) ? 1.0 : 0.5)
                    
                }.padding()
                
            }
            .toolbar {
                //Button("Paste", action: dataService.paste) //is not working
                Button("Clear Data") {
                    clearData()
                }
                Button("Submit") {
                    dataService.updateData(withText: dataField)
                }
            }
        }.onAppear(perform: loadTextFromService)
            .onChange(of: dataService.nudgedFunctionCurve) { _ in
                dataService.saveSettings()
            }
        
        
        
    }
    
    func loadTextFromService() {
        dataField = dataService.datatext ?? ""
    }
    
    func clearData() {
        dataField = "" //prevents visual blip
        dataService.reset()
        //print(("DataEntryView.clearData: \(dataService.datatext)"))
        //Confirms that dataService.datatext is empty.
        loadTextFromService()
    }
}


struct DataEntryView_Previews: PreviewProvider {
    static var previews: some View {
        DataEntryView().environmentObject(DataManager())
    }
}
