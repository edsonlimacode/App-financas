//
//  Installment.swift
//  MinhasFinancas
//
//  Created by edson lima on 25/02/26.
//

import Foundation
import Supabase

struct Installment: Codable {
    
    let id: Int?
    let total: Double?
    let recurrency: String?
    let quantity: Int?
    let userid: UUID?
    
    init(total: Double, recurrency: String, quantity: Int) {
        self.id = nil
        self.total = total
        self.recurrency = recurrency
        self.quantity = quantity
        self.userid = supabase.auth.currentUser?.id
    }
}
