//
//  Double+Ext.swift
//  MinhasFinancas
//
//  Created by edson lima on 27/02/26.
//
import Foundation

extension Double {
    
    
    func ptBrCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = "BRL"
        return formatter.string(from: NSNumber(value: self)) ?? "R$ 0,00"
    }
    
}
