//
//  LoginViewController.swift
//  MinhasFinancas
//
//  Created by edson lima on 12/02/26.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    private let loginView = LoginView()
    private let authViewModel = AuthViewModel()
    private var flowCoordinator: LoginFlowDelegate?
    private weak var activeTextField: UITextField?

    init(flowCoordinatorDelegate: LoginFlowDelegate? = nil) {
        self.flowCoordinator = flowCoordinatorDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
        tapToNextField()
        setupActions()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func loadView() {
        self.view = loginView
    }

    private func setupActions() {

        loginView.makeLogin = { [weak self] email, password in

            let isEmptyFields = self?.authViewModel.isValid(name: nil, email: email, password: password, validationType: .login)

            if isEmptyFields == true {

                self?.showAlert(title: "Campos vazios", message: "Verifique se todos os campo estão preenchidos")
                return
            }

            guard let email, let password else { return }

            Task { [weak self] in
                do {
                    try await self?.authViewModel.login(email: email, password: password)

                    if !UserDefaultsManager.isFaceIdEnabled() {

                        let alert = UIAlertController(
                            title: "Ativar FaceID",
                            message: "Deseja ativar a FaceID?",
                            preferredStyle: .alert
                        )

                        let action = UIAlertAction(
                            title: "Sim",
                            style: .default,
                            handler: { _ in

                                UserDefaultsManager.enableFaceId()

                                self?.flowCoordinator?.navigateToHome()
                            }
                        )

                        let cancel = UIAlertAction(title: "Não", style: .cancel) { _ in
                            self?.flowCoordinator?.navigateToHome()
                        }

                        alert.addAction(action)
                        alert.addAction(cancel)

                        self?.present(alert, animated: true)

                    } else {
                        self?.flowCoordinator?.navigateToHome()
                    }

                } catch {
                    self?.showAlert(title: "Email ou senha incorretos", message: "Verifique os seus dados e tente novamente")
                }
            }
        }

        loginView.onNavigateToRegister = {
            self.flowCoordinator?.navigateToRegister()
        }
    }
}

extension LoginViewController: UITextFieldDelegate {

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

        UIView.animate(withDuration: 0.3) {
            // O transform move a view inteira no eixo Y negativamente do tamanho do teclado
            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight / 1.1)
        }
    }

    @objc
    private func keyboardWillHide() {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }

    //Esconde o teclado, após tocar na tela
    private func setupTapToDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.loginView.addGestureRecognizer(tapGesture)
    }

    @objc
    private func dismissKeyboard() {
        self.loginView.endEditing(true)
    }

    //Manipula o action button do teclado
    private func tapToNextField() {

        self.loginView.emailInputField.textField.delegate = self
        self.loginView.passwordInputField.textField.delegate = self

        self.loginView.emailInputField.textField.returnKeyType = .next
        self.loginView.passwordInputField.textField.returnKeyType = .done
    }

    //pula para o proximo campo
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let email = self.loginView.emailInputField.textField
        let password = self.loginView.passwordInputField.textField

        if textField == email {
            password.becomeFirstResponder()
        } else if textField == password {
            textField.resignFirstResponder()
        }

        return true
    }
}
