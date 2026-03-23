//
//  BottomSheetFormController.swift
//  MinhasFinancas
//
//  Created by edson lima on 24/02/26.
//

import Foundation
import UIKit

enum InvoiceType: String, Codable {
    case income
    case expense
}

class BottomSheetFormController: UIViewController {

    private var invoiceType: InvoiceType?
    private var isSaving = false

    let bottomSheetFormView = BottomSheetFormView()
    let viewModel = BottomSheetFormViewModel()
    let invoice: Invoice?

    init(invoiceType: InvoiceType, invoice: Invoice? = nil) {

        self.invoiceType = invoiceType

        self.invoice = invoice

        super.init(nibName: nil, bundle: nil)

        if invoiceType == .expense {
            bottomSheetFormView.saveButton.backgroundColor = Colors.red600
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomSheetForm()
        setupRecurrencySelect()
        setupDatePicker()
        setupRecurrencyQuantityPicker()
        setupActions()
        setupBinds()
        setupFieldsToUpdate()
        setupDelegates()
        setupInputToReturn()
    }

    private func setupBinds() {
        viewModel.onInvoiceSaved = {
            NotificationCenter.default.post(name: NSNotification.Name("invoiceSaved"), object: nil)
        }
    }

    private func setupDelegates() {
        bottomSheetFormView.inputQuantityRecurrency.delegate = self
        bottomSheetFormView.inputDate.textField.delegate = self
        bottomSheetFormView.inputDescription.textField.delegate = self
    }

    private func setupFieldsToUpdate() {
        guard let invoice else { return }

        bottomSheetFormView.inputDate.textField.text = invoice.dueDate
        bottomSheetFormView.inputDate.textField.isEnabled = false
        bottomSheetFormView.inputDate.textField.backgroundColor = Colors.gray100
        bottomSheetFormView.inputDate.textField.textColor = Colors.gray400

        bottomSheetFormView.titleRecurrency.isHidden = true
        bottomSheetFormView.inputRecurrency.isHidden = true

        bottomSheetFormView.inputValue.textField.text = invoice.value.ptBrCurrency()
        bottomSheetFormView.inputDescription.textField.text = invoice.description

        bottomSheetFormView.saveButton.setTitle("Atualizar", for: .normal)
    }

    private func setupBottomSheetForm() {

        if let sheet = self.sheetPresentationController {

            sheet.prefersGrabberVisible = true

            sheet.detents = [.medium()]
        }
    }

    private func setupRecurrencySelect() {

        bottomSheetFormView.typeRecurrency.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleRecurrency))
        )

    }

    @objc private func handleRecurrency() {

        let alert = UIAlertController(title: "Escolha a Recurrencia", message: nil, preferredStyle: .actionSheet)

        let option1 = UIAlertAction(title: "Parcelada", style: .default) { [weak self] _ in
            self?.bottomSheetFormView.typeRecurrency.text = "Parcelada"
        }

        let option2 = UIAlertAction(title: "Fixa", style: .default) { [weak self] _ in
            self?.bottomSheetFormView.typeRecurrency.text = "Fixa"
        }

        alert.addAction(option1)
        alert.addAction(option2)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))

        self.present(alert, animated: true)

    }

    private func setupDatePicker() {

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapSelectDate))

        //padding a esquersa e a direitra
        let flexSpaceLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexSpaceRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCancelDate))

        toolbar.setItems([cancelButton, flexSpaceRight, flexSpaceLeft, doneButton], animated: false)

        bottomSheetFormView.inputDate.textField.inputView = bottomSheetFormView.datePicker
        bottomSheetFormView.inputDate.textField.inputAccessoryView = toolbar

    }

    @objc private func didTapSelectDate() {

        let dateString = bottomSheetFormView.datePicker.date.formatted(date: .numeric, time: .omitted)
        bottomSheetFormView.inputDate.textField.text = dateString
        bottomSheetFormView.inputDate.textField.endEditing(true)
    }

    @objc private func didTapCancelDate() {
        bottomSheetFormView.inputDate.textField.endEditing(true)
    }

    private func setupRecurrencyQuantityPicker() {

        let input = bottomSheetFormView.inputQuantityRecurrency
        let picker = bottomSheetFormView.recurrencyQuntityPicker

        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        //padding a esquersa e a direitra
        let flexSpaceLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexSpaceRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapSelectQuantity))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCancel))

        toolBar.setItems([cancelButton, flexSpaceLeft, flexSpaceRight, doneButton], animated: true)

        input.inputView = picker

        input.inputAccessoryView = toolBar

        picker.delegate = self
        picker.dataSource = self
    }

    @objc
    private func didTapSelectQuantity() {

        let input = bottomSheetFormView.inputQuantityRecurrency
        let picker = bottomSheetFormView.recurrencyQuntityPicker

        let value = picker.selectedRow(inComponent: 0)

        let selectedValue = viewModel.generateRecurrencies()[value].description

        input.text = selectedValue

        input.endEditing(true)
    }

    @objc
    private func didTapCancel() {
        bottomSheetFormView.inputQuantityRecurrency.endEditing(true)
    }

    //MARK: Actions
    private func setupActions() {

        let inputValue = bottomSheetFormView.inputValue.textField
        let inputRecurrency = bottomSheetFormView.inputRecurrency
        let inputType = bottomSheetFormView.typeRecurrency
        let inputQuantityRecurrency = bottomSheetFormView.inputQuantityRecurrency

        inputValue.addAction(
            UIAction(handler: { _ in

                guard let text = inputValue.text else { return }

                let cleanText = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

                inputValue.text = cleanText.currencyFormatted()

            }),
            for: .editingChanged
        )

        inputRecurrency.addAction(
            UIAction(handler: { action in

                guard let sender = action.sender as? UISwitch else { return }

                inputType.text = sender.isOn ? "Parcelada" : "Unica"
                inputType.isHidden = !sender.isOn
                inputQuantityRecurrency.isHidden = !sender.isOn

            }),
            for: .valueChanged
        )

        bottomSheetFormView.saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
    }

    @objc
    private func didTapSave() { //aqui salva
        guard !isSaving else { return }

        let value = bottomSheetFormView.inputValue.textField.text ?? ""
        let date = bottomSheetFormView.inputDate.textField.text ?? ""
        let description = bottomSheetFormView.inputDescription.textField.text ?? ""
        let typeRecurrency = bottomSheetFormView.typeRecurrency.text ?? ""
        let quantityRecurrency = bottomSheetFormView.inputQuantityRecurrency.text ?? ""

        let validation = viewModel.isValid(value: value, description: description, dueDate: date)

        if !validation {
            showAlert(title: "Campos com * obrigatórios", message: "Preencha os campos valor, data de vencimento e descrição")
            return
        }

        guard let type = invoiceType else { return }

        let invoiceToSave = Invoice(
            id: invoice?.id,
            description: description,
            value: value.convertToDouble(),
            month: DateUtils.formatMonth.string(from: date.convertToDate()),
            dueDate: date,
            status: "aberta",
            type: type.rawValue,
            installmentId: nil,
            installment: Int(quantityRecurrency) ?? 1
        )

        Task { [weak self] in
            guard let self else { return }
            
            await MainActor.run {
                self.setSavingState(isSaving: true)
            }

            do {
                try await self.viewModel.saveInvoice(invoice: invoiceToSave, recurrency: typeRecurrency)
                
                NotificationManager.shared.setupNotification(dueDate: date)

                NotificationCenter.default.post(name: NSNotification.Name("invoiceCreated"), object: nil)
                
                await MainActor.run {
                    self.dismiss(animated: true)
                }
            } catch {
                print(error)
                await MainActor.run {
                    self.setSavingState(isSaving: false)
                }
            }

        }
    }

    private func setSavingState(isSaving: Bool) {
        self.isSaving = isSaving
        bottomSheetFormView.saveButton.isEnabled = !isSaving
        bottomSheetFormView.saveButton.alpha = isSaving ? 0.7 : 1
    }

    override func loadView() {
        super.loadView()

        view = bottomSheetFormView
    }
}

//MARK: Extensions
extension BottomSheetFormController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        let quantity = viewModel.generateRecurrencies().count

        return quantity
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return viewModel.generateRecurrencies()[row].description
    }

}

extension BottomSheetFormController: UITextFieldDelegate {

    //bloqueia a digitação no campo, enquanto o picker ou modal tiver aberto
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == self.bottomSheetFormView.inputDate.textField
            || textField == self.bottomSheetFormView.inputQuantityRecurrency
        {
            return false
        }

        return true
    }

    private func setupInputToReturn() {
        self.bottomSheetFormView.inputDate.textField.returnKeyType = .done
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == self.bottomSheetFormView.inputDescription.textField {
            textField.resignFirstResponder()
        }

        return true

    }
}
