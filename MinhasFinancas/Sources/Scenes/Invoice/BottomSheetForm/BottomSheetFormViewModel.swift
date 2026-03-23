//
//  BottomSheetFormViewModel.swift
//  MinhasFinancas
//
//  Created by edson lima on 25/02/26.
//

import Foundation
import Supabase

class BottomSheetFormViewModel {

    var onInvoiceSaved: (() -> Void)?
    
    func generateRecurrencies() -> [Int] {
        return Array(1...60)
    }

    func saveInvoice(invoice: Invoice, recurrency: String) async throws {
        if invoice.id != nil {
            try await supabase.from("invoices")
                .update(["value": invoice.value.description, "description": invoice.description])
                .eq("id", value: invoice.id)
                .execute()
            onInvoiceSaved?()
        } else {

            switch recurrency {
                
            case "Unica":
                try await supabase.from("invoices")
                    .insert(invoice)
                    .execute()
                onInvoiceSaved?()
            case "Fixa":
                guard let quantity = invoice.installment else { return }
                
                let invoices = try await buildRecurringInvoices(
                    from: invoice,
                    recurrency: recurrency,
                    quantity: quantity,
                    installmentValue: invoice.value
                )

                try await supabase.from("invoices")
                    .insert(invoices)
                    .execute()
                onInvoiceSaved?()
            case "Parcelada":
                guard let quantity = invoice.installment else { return }
                
                let value = invoice.value / Double(quantity)
                
                let invoices = try await buildRecurringInvoices(
                    from: invoice,
                    recurrency: recurrency,
                    quantity: quantity,
                    installmentValue: value
                )

                try await supabase.from("invoices")
                    .insert(invoices)
                    .execute()
                
                onInvoiceSaved?()
            default:
                break
            }

        }
    }

    private func buildRecurringInvoices(
        from invoice: Invoice,
        recurrency: String,
        quantity: Int,
        installmentValue: Double
    ) async throws -> [Invoice] {
        let installment = Installment(total: invoice.value, recurrency: recurrency, quantity: quantity)

        let installmentResult: Installment = try await supabase.from("installment")
            .insert(installment)
            .select("id")
            .single()
            .execute()
            .value

        let calendar = Calendar.current
        let baseDate = invoice.dueDate.convertToDate()

        return try (1...quantity).map { index in
            
            guard let dueDate = calendar.date(byAdding: .month, value: index, to: baseDate) else {
                throw NSError(domain: "BottomSheetFormViewModel", code: 1)
            }

            return Invoice(
                description: invoice.description,
                value: installmentValue,
                month: DateUtils.formatMonth.string(from: dueDate),
                dueDate: dueDate.formatted(
                    date: .numeric,
                    time: .omitted
                ),
                status: "aberto",
                type: invoice.type,
                installmentId: installmentResult.id,
                installment: index
            )
        }
    }

    func isValid(value: String, description: String, dueDate: String) -> Bool {
        if value.isEmpty || description.isEmpty || dueDate.isEmpty {
            return false
        }

        return true
    }
    

}
