//
//  IncomeViewModel.swift
//  MinhasFinancas
//
//  Created by edson lima on 20/02/26.
//

import Foundation
import Supabase

class InvoiceViewModel: AnyObject {

    var onMonthSelected: ((Int) -> Void)?
    var onInvoicesUpdated: (() -> Void)?

    private let invoiceType: InvoiceType?

    private(set) var months: [String] = []
    var currentInvoices: [Invoice] = []

    private(set) var selectedDate: String?

    init(invoiceType: InvoiceType) {

        self.invoiceType = invoiceType

        generateMonths()

    }

    var numberOfRows: Int {
        return months.count
    }

    //gera 12 mês para frente e para trás, apartir do mês atual
    private func generateMonths() {

        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        calendar.locale = Locale(identifier: "pt_BR")

        let today = Date()

        for i in -13..<11 {
            if let date = calendar.date(byAdding: .month, value: i, to: today) {
                months.append(DateUtils.formatMonth.string(from: date))
            }
        }
    }

    private func selectMonth(at index: Int) {
        guard index >= 0 && index < months.count else { return }

        selectedDate = months[index]

        Task {
            await getInvoicesByMonth(month: selectedDate!)
        }

        onMonthSelected?(index)

    }

    //obtem o mês atual
    func getMonth() {

        let startOfCurrentMonth = DateUtils.formatMonth.string(from: Date())

        if let index = months.firstIndex(where: { $0 == startOfCurrentMonth }) {
            selectMonth(at: index)
        }
    }

    func getMonth(month: String) {
        if let index = months.firstIndex(where: { $0 == month }) {
            selectMonth(at: index)
        }
    }

    func isCurrentMonth(at index: Int) -> Bool {
        let date = months[index]

        let currentMonth = DateUtils.formatMonth.string(from: Date())
        return date == currentMonth
    }

    func titleForMonth(at index: Int) -> String {
        let date = months[index]
        return date
    }

    func getInvoicesByMonth(month: String) async {
        do {

            guard let userId = supabase.auth.currentUser?.id else { return }

            let response: [Invoice] =
                try await supabase
                .from("invoices")
                .select()
                .eq("month", value: month)
                .eq("userid", value: userId)
                .eq("type", value: invoiceType?.rawValue)
                .execute()
                .value

            self.currentInvoices = response
            self.onInvoicesUpdated?()
        } catch {
            print("Failed to fetch invoices:", error)
        }
    }

    func getTotal() -> String {

        let total = currentInvoices.reduce(0) { $0 + $1.value }

        return total.ptBrCurrency()
    }

    func deleteAll(installmentId: Int) async {

        do {

            try await supabase.from("invoices")
                .delete()
                .eq("installmentId", value: installmentId)
                .execute()

            try await supabase.from("installment")
                .delete()
                .eq("id", value: installmentId)
                .execute()

            onInvoicesUpdated?()
        } catch {
            print(error.localizedDescription)
        }

    }

    func deleteSingle(invoiceId: Int) async {

        do {

            try await supabase.from("invoices")
                .delete()
                .eq("id", value: invoiceId)
                .execute()

            onInvoicesUpdated?()
        } catch {
            print(error.localizedDescription)
        }

    }
}
