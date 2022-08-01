//
//  DataParser.swift
//  DataViewer
//
//  Created by Labtanza on 7/31/22.
//

import Foundation
import DataHelper


struct DataParser {
    
    func parseData(from text:String, withStrategy strategy:ParseStrategy) -> [DataPoint]{
        var lines:[String.SubSequence] = []
        var dataHopper:[DataPoint] = []
        
        switch strategy {
            
        case .lineDelimited:
            lines = text.split(separator:"\n")
        case .arrayPrint:
            lines = text.split(separator:"), (")
        }
        
        for line in lines {
            if let dataPoint = dataPointFromLine(String(line)){
                dataHopper.append(dataPoint)
            }
        }

        return dataHopper
    }
    
    func parseLine(_ line:String) -> (x:Double, y:Double)? {
        let charsetToTrim = CharacterSet(charactersIn: "0123456789.").inverted
        let parts = line.split(separator: ",", omittingEmptySubsequences: false)
        guard parts.count == 2 else {
            return nil
        }
        guard let x = Double(parts[0].trimmingCharacters(in: charsetToTrim)), let y = Double(parts[1].trimmingCharacters(in: charsetToTrim)) else {
            return nil
        }
        return (x, y)
    }
    
    func dataPointFromLine(_ line:String) -> Datum? {
        if let result = parseLine(line) {
            return Datum(x:result.x, y: result.y)
        }
        return nil
    }
    
    enum ParseStrategy {
        case lineDelimited
        case arrayPrint
    }
}


