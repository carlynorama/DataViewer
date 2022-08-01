//
//  EnumPicker.swift
//  DataViewer
//
//  Created by Labtanza on 8/1/22.
//

import SwiftUI



protocol PickerSuppliable:CaseIterable, Hashable {
    var menuText:String { get }
}

fileprivate enum TestEnum:PickerSuppliable{
    //var id:TestEnum { self }
    
    case yes, no, maybe
    
    var menuText: String {
        switch self {
            
        case .yes:
            return "Yes"
        case .no:
            return "No"
        case .maybe:
            return "Maybe"
        }
    }
}

struct EnumPicker<E:PickerSuppliable>: View {
    let options:[E] = E.allCases as! [E]
    @Binding var value:E

    var body: some View {
        VStack {
            VStack {
                Picker("Favorite Color", selection: $value) {
                    //ForEach(options) { option in is only for identifiable
                    ForEach(options, id: \.self) { option in
                        Text(option.menuText)
                    }
                }
            }
        }
    }
}

struct EnumPicker_Previews: PreviewProvider {
    static var previews: some View {
            EnumPicker<TestEnum>(value: .constant(.maybe))
    }
}
