//
//  LoginView.swift
//  MinhasFinancas
//
//  Created by edson lima on 12/02/26.
//

import Foundation
import UIKit

class LoginView: UIView {

    var makeLogin: ((String?, String?) -> Void)?
    var onNavigateToRegister: (() -> Void)?
   
    private lazy var titleLabel = {
        let title = UILabel()
        title.text = "Entrar"
        title.font = .systemFont(ofSize: 36, weight: .semibold)
        title.textColor = Colors.gray100
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    private lazy var subTitleLabel = {
        let title = UILabel()
        title.text = "Faça seu login"
        title.font = .systemFont(ofSize: 16, weight: .semibold)
        title.textColor = Colors.gray100
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    private lazy var titleStack = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            subTitleLabel,
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var logoImageView = {
        let imageView = UIImageView()
        imageView.image = .logo
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var contentLoginView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 420).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var mainStack = {
        let stack = UIStackView(arrangedSubviews: [
            titleStack,
            logoImageView,
        ])
        stack.setCustomSpacing(80, after: titleStack)
        stack.axis = .vertical
        stack.spacing = 32
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var emailInputField = {
        let input = InputTextField(textLabel: "E-mail", placeholder: "Ex: exemplo@email.com")
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()

    lazy var passwordInputField = {
        let input = InputTextField(textLabel: "Senha", placeholder: "Senha")
        input.textField.isSecureTextEntry = true
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()

    private lazy var buttonNewAccount = {
        let button = UIButton(type: .system)
        button.setTitle("Ainda não tem conta ? cadastre-se", for: .normal)
        button.setTitleColor(Colors.gray700, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var loginButton = {
        let button = UIButton(type: .system)
        button.setTitle("Entrar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.green600
        button.layer.cornerRadius = 24
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var loginStack = {
        let stack = UIStackView(arrangedSubviews: [
            emailInputField,
            passwordInputField,
            buttonNewAccount,
            loginButton,
        ])
        stack.setCustomSpacing(32, after: buttonNewAccount)
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = Colors.green500

        setupViews()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {

        addSubview(mainStack)
        addSubview(contentLoginView)
        contentLoginView.addSubview(loginStack)

        setupConstraints()
    }

    //MARK: objc
    @objc
    private func didTapLogin() {

        let email = emailInputField.textField.text ?? ""
        let password = passwordInputField.textField.text ?? ""

        self.makeLogin?(email, password)
    }

    @objc
    private func didTapRegister() {
        self.onNavigateToRegister?()
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            mainStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 52),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),

            contentLoginView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentLoginView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentLoginView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            loginStack.topAnchor.constraint(equalTo: contentLoginView.topAnchor, constant: 32),
            loginStack.leadingAnchor.constraint(equalTo: contentLoginView.leadingAnchor, constant: 24),
            loginStack.trailingAnchor.constraint(equalTo: contentLoginView.trailingAnchor, constant: -24),

        ])
    }

}
