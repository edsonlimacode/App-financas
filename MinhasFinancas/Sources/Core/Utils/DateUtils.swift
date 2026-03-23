//
//  Date.swift
//  MinhasFinancas
//
//  Created by edson lima on 25/02/26.
//

import Foundation

class DateUtils {
    
    static let formatMonth = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter
    }()
    
}
