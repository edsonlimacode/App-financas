//
//  InputTextField.swift
//  MinhasFinancas
//
//  Created by edson lima on 12/02/26.
//

import Foundation
import UIKit

class InputTextField: UIView {
    
    lazy var lable = {
        let label = UILabel()
        label.textColor = Colors.gray700
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField = {
        let textField = UITextField()
        textField.backgroundColor = Colors.gray200
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    init(textLabel: String, placeholder: String) {
        
        super.init(frame: .zero)
        
        lable.text = textLabel
        textField.placeholder = placeholder
    
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        addSubview(lable)
        addSubview(textField)
    
        self.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            lable.topAnchor.constraint(equalTo: topAnchor),
            lable.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            textField.topAnchor.constraint(equalTo: lable.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 52)
        ])
        
    }
}
