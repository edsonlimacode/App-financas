//
//  String+Ext.swift
//  MinhasFinancas
//
//  Created by edson lima on 26/02/26.
//

import Foundation

extension String {

    func currencyFormatted() -> String {

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "BRL"
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2

        if self.isEmpty {
            return numberFormatter.string(from: NSNumber(value: 0)) ?? ""
        }

        let doubleValue = (self as NSString).doubleValue
        let value = NSNumber(value: (doubleValue / 100))

        return numberFormatter.string(from: value) ?? ""
    }

    func convertToDouble() -> Double {
        //101,33
        let cleanText =
            self.replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: "R$", with: "")
            .trimmingCharacters(in: .whitespaces)

        return Double(cleanText) ?? 0.0
    }

    func convertToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: self) ?? Date()
    }
}
