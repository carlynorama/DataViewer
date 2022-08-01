//
//  DataEntryView.swift
//  DataViewer
//
//  Created by Labtanza on 7/31/22.
//

import SwiftUI

struct DataEntryView: View {
    @EnvironmentObject var dataService:DataManager
    
    @State var dataField:String = ""
    @State var parseStrategy:DataParser.ParseStrategy = .lineDelimited
    
    var body: some View {
        NavigationStack {
           
                VStack {
                    Form {
                        Picker("Parse Strategy", selection: $parseStrategy) {
                            Text("Line Delimited").tag(DataParser.ParseStrategy.lineDelimited)
                            Text("Array of Tuples").tag(DataParser.ParseStrategy.arrayPrint)
                        }.pickerStyle(.segmented)
                        
                    ScrollView {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            ZStack(alignment:.topLeading) {

                                //Text(viewModel.availablePasteboardTypes).font(.body)
                                TextEditor(text:$dataField).font(.body.monospaced())
                                if dataField.isEmpty {
                                    Text("enter or paste your data here").foregroundColor(Color(UIColor.systemGray5)).allowsHitTesting(false)
                                }
                            }
                            
                        }
                    }
                    .padding()

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
