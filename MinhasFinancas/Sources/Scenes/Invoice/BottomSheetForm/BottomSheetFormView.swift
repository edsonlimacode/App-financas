//
//  BottomSheetView.swift
//  MinhasFinancas
//
//  Created by edson lima on 24/02/26.
//

import Foundation
import UIKit

protocol BottomSheetFormDelegate: AnyObject {
    func openBottomSheet()
}

class BottomSheetFormView: UIView {

    private lazy var scrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    lazy var inputValue = {
        let input = InputTextField(textLabel: "Valor*", placeholder: "R$ 0,00")
        input.textField.keyboardType = .numberPad
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()

    lazy var inputDate = {
        let input = InputTextField(textLabel: "Data*", placeholder: "Ex: 00/00/0000")
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()

    lazy var inputDescription = {
        let input = InputTextField(textLabel: "Descrição*", placeholder: "Ex: supermercado")
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()

    lazy var titleRecurrency = {
        let label = UILabel()
        label.text = "Recorrente ?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var inputRecurrency = {
        let switchView = UISwitch()
        switchView.onTintColor = Colors.green400
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }()

    lazy var typeRecurrency = {
        let text = UILabel()
        text.isUserInteractionEnabled = true
        text.backgroundColor = Colors.gray200
        text.layer.cornerRadius = 12
        text.textAlignment = .center
        text.layer.masksToBounds = true
        text.text = "Unica"
        text.textColor = Colors.gray700
        text.isHidden = true
        text.widthAnchor.constraint(equalToConstant: 122).isActive = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "pt_BR")
        return picker
    }()
    
    lazy var recurrencyQuntityPicker = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var inputQuantityRecurrency = {
        let input = UITextField()
        input.backgroundColor = Colors.gray200
        input.layer.cornerRadius = 10
        input.isHidden = true
        input.textAlignment = .center
        input.keyboardType = .numberPad
        input.widthAnchor.constraint(equalToConstant: 50).isActive = true
        input.textColor = Colors.gray700
        input.placeholder = "Ex: 12"
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()

    lazy var stackRecurrency = {
        let stack = UIStackView(arrangedSubviews: [
            titleRecurrency,
            inputRecurrency,
            typeRecurrency,
            inputQuantityRecurrency,
        ])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var saveButton = {
        let button = UIButton(type: .system)
        button.setTitle("Salvar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24
        button.backgroundColor = Colors.green600
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var stackValueDate = {
        let stack = UIStackView(arrangedSubviews: [inputValue, inputDate])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(stackValueDate)
        scrollView.addSubview(inputDescription)
        scrollView.addSubview(stackRecurrency)
        scrollView.addSubview(saveButton)
        setupConstraints()
    }

    
    func configure(invoice: Invoice) {
        self.inputDescription.textField.text = invoice.description
    }

    private func setupConstraints() {

        let scrollContentArea = scrollView.contentLayoutGuide
        let scrollFrameGuide = scrollView.frameLayoutGuide

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollContentArea.widthAnchor.constraint(equalTo: scrollFrameGuide.widthAnchor),

            stackValueDate.topAnchor.constraint(equalTo: scrollContentArea.topAnchor, constant: 62),
            stackValueDate.leadingAnchor.constraint(equalTo: scrollContentArea.leadingAnchor),
            stackValueDate.trailingAnchor.constraint(equalTo: scrollContentArea.trailingAnchor),

            inputDescription.topAnchor.constraint(equalTo: stackValueDate.bottomAnchor),
            inputDescription.leadingAnchor.constraint(equalTo: scrollContentArea.leadingAnchor),
            inputDescription.trailingAnchor.constraint(equalTo: scrollContentArea.trailingAnchor),

            stackRecurrency.topAnchor.constraint(equalTo: inputDescription.bottomAnchor, constant: 20),

            saveButton.topAnchor.constraint(equalTo: stackRecurrency.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: scrollContentArea.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: scrollContentArea.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
