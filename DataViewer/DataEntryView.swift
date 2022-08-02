//
//  DataEntryView.swift
//  DataViewer
//
//  Created by Labtanza on 7/31/22.
//

import SwiftUI

extension DataParser.ParseStrategy:PickerSuppliable {
    
    var menuText: String {
        switch self {
            
        case .lineDelimited:
            return "Line Delimited"
        case .arrayPrint:
            return "Array of Tuples"
        }
    }
}

struct DataEntryView: View {
    @EnvironmentObject var dataService:DataManager
    
    @State var dataField:String = ""
    @FocusState var dataFieldHasFocus:Bool
    
    @State var returnSubmit:Bool = true
    
    var body: some View {
        NavigationStack {
            
            Form {
                ScrollView {
                    VStack {
                        EnumPicker(value: $dataService.parseStrategy).pickerStyle(.segmented)
                        
                        Toggle("Return submit", isOn: $returnSubmit)
                        
                        
                        TextField("Datapoint entry", text: $dataField, prompt: Text("enter or paste your data here"), axis: .vertical).onSubmit {
                            if returnSubmit {
                                dataField.append("\n")
                                dataService.updateData(withText: dataField)
                                dataFieldHasFocus = true
                            }
                        }
                        .lineLimit(10...)
                        .font(.body.monospaced())
                        .focused($dataFieldHasFocus)
                    }.padding()
                }
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
