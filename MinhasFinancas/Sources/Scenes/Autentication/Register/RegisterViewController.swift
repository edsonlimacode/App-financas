//
//  RegisterViewController.swift
//  MinhasFinancas
//
//  Created by edson lima on 13/02/26.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {

    private let registerView = RegisterView()
    private let authViewModel = AuthViewModel()
    weak var flowDelegate: RegisterFlowDelegate?

    init(flowDelegate: RegisterFlowDelegate) {
        self.flowDelegate = flowDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
        setupActions()
        setupTapNextField()
    }

    override func loadView() {
        view = registerView
    }

    private func setupActions() {

        registerView.makeRegister = { [weak self] name, email, password in

            let isEmptyFields = self?.authViewModel.isValid(
                name: name,
                email: email,
                password: password,
                validationType: .register
            )

            if isEmptyFields == true {

                self?.showAlert(title: "Campos vazios", message: "Verifique se todos os campo estão preenchidos")

                return

            }

            guard let name, let email, let password else { return }

            Task { [weak self] in

                do {
                    try await self?.authViewModel.register(name: name, email: email, password: password)

                    self?.showAlert(title: "Sucesso", message: "Usuário criado com sucesso!") {
                        self?.flowDelegate?.navigateToLogin()
                    }

                } catch {

                    if error.localizedDescription.localizedCaseInsensitiveContains("Password") {
                        self?.showAlert(title: "Senha fraca", message: "Senha deve conter no minimo 6 caracteres")
                    } else if error.localizedDescription.localizedCaseInsensitiveContains("registered") {
                        self?.showAlert(title: "E-mail já cadastrado", message: "E-mail já está sendo utilizado")
                    } else if error.localizedDescription.localizedCaseInsensitiveContains("invalid format") {
                        self?.showAlert(title: "E-mail inválido", message: "Verifique o formato do e-mail")
                    } else {
                        self?.showAlert(title: "Erro", message: error.localizedDescription)
                    }
                }
            }
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardHeight = keyboardFrame.cgRectValue.height

        UIView.animate(withDuration: 2.0) {
            // O transform move a view inteira no eixo Y de forma limpa
            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight / 1.1)
        }
    }

    @objc
    private func keyboardWillHide() {
        UIView.animate(withDuration: 2.0) {
            self.view.transform = .identity
        }
    }

    private func setupTapToDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        tapGesture.cancelsTouchesInView = false
        self.registerView.addGestureRecognizer(tapGesture)
    }

    @objc
    private func dismissKeyboard() {
        self.registerView.endEditing(true)
    }

    //Manipula o action button do teclado
    private func setupTapNextField() {
        
        registerView.nameInputField.textField.delegate = self
        registerView.emailInputField.textField.delegate = self
        registerView.passwordInputField.textField.delegate = self
        
        registerView.emailInputField.textField.returnKeyType = .next
        registerView.nameInputField.textField.returnKeyType = .next
        registerView.passwordInputField.textField.returnKeyType = .done
    }

    //pula para o proximo campo
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let name = registerView.nameInputField.textField
        let email = registerView.emailInputField.textField
        let passoword = registerView.passwordInputField.textField

        if textField == name {
            email.becomeFirstResponder()
        } else if textField == email {
            passoword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }

}
