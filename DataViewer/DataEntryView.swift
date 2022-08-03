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
    static var labelText: String = "Fit Strategy"
    var menuText: String {
        self.description
    }
}

struct DataEntryView: View {
    @EnvironmentObject var dataService:DataManager
    
    @State var dataField:String = ""
    @FocusState var dataFieldHasFocus:Bool
    
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
                            
                            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20) {
                                GridRow {
                                    Text("Try Curve:")
                                    EnumPicker<CurveProfile>(value: $dataService.curve)
                                    Button("Run Fit", action: dataService.updateCurveFit)
                                }
                                
                                GridRow {
                                    Text("Error Analysis:")
                                    Text("[options]").foregroundColor(.secondary)
                                    Button("Run Analysis", action: dataService.updateErrorAnalysis)
                                }
                            }
                        }.opacity((dataService.data.count > 3) ? 1.0 : 0.5)
                      
                        Section {
                            Button("Load Curve To Edit", action: dataService.updateNundgedWithFit)
                            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20) {
                                GridRow {
                                    Text("Nudge Curve:")
                                    EnumPicker<CurveProfile>(value: $dataService.nudgedFunctionCurve)
                                }
                                if dataService.nudgedFunctionParameters.count >= 1 {
                                    GridRow {
                                        Text("Paramter 1")
                                        TextField("Paramter 1", value: $p1, format: .number)
                                    }
                                }
                                if dataService.nudgedFunctionParameters.count >= 2 {
                                    GridRow {
                                        Text("Paramter 2")
                                        TextField("Paramter 2", value: $p2, format: .number)
                                    }
                                }
                                if dataService.nudgedFunctionParameters.count >= 3 {
                                    GridRow {
                                        Text("Paramter 3")
                                        TextField("Paramter 3", value: $p3, format: .number)
                                    }
                                }
                                Button("Nudge", action: dataService.buildNudge([p1, p2, p3]))
                                
                            }.opacity((dataService.data.count > 3) ? 1.0 : 0.5)
                        }
                        
                    }.padding()
                
            }.toolbar {
                //Button("Paste", action: dataService.paste) //is not working
                Button("Submit") {
                    dataService.updateData(withText: dataField)
                }
            }
        }
        
    }
}


struct DataEntryView_Previews: PreviewProvider {
    static var previews: some View {
        DataEntryView().environmentObject(DataManager())
    }
}
