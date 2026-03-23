//
//  Invoice.swift
//  MinhasFinancas
//
//  Created by edson lima on 20/02/26.
//

import Foundation
import Supabase

struct Invoice: Codable {
    let id: Int?
    let userid: UUID
    let description: String
    var value: Double
    let month: String
    var dueDate: String
    let status: String?
    let type: String
    let installmentId: Int?
    var installment: Int?

    init(
        id: Int? = nil,
        description: String,
        value: Double,
        month: String,
        dueDate: String,
        status: String?,
        type: String,
        installmentId: Int?,
        installment: Int?
    ) {
        
        self.id = id
        self.userid = supabase.auth.currentUser?.id ?? UUID()
        self.description = description
        self.value = value
        self.month = month
        self.dueDate = dueDate
        self.status = status
        self.type = type
        self.installmentId = installmentId
        self.installment = installment
    }

}
