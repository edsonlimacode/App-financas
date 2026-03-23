//
//  MyFinancesCordinate.swift
//  MinhasFinancas
//
//  Created by edson lima on 12/02/26.
//

import Foundation
import UIKit

class AppCordinator {

    private var navigationController: UINavigationController?

    func start() -> UIViewController? {
        let splashController = SplashController(flowCoordinator: self)

        self.navigationController = UINavigationController(rootViewController: splashController)

        return self.navigationController
    }

    public init() {}

}

extension AppCordinator {

    func navigateToLogin() {
        let loginViewController = LoginViewController(flowCoordinatorDelegate: self)
        self.navigationController?.setViewControllers([loginViewController], animated: true)
    }

    func navigateToRegister() {
        let registerViewController = RegisterViewController(flowDelegate: self)
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func navigateToHome() {
        let tabBarViewController = TabBarViewController(invoiceDelegate: self)
        tabBarViewController.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.pushViewController(tabBarViewController, animated: true) // setViewContollers evita o botao voltar
    }
}

extension AppCordinator: SplashFlowDelegate {}
extension AppCordinator: InvoiceFlowDelegate {}
extension AppCordinator: LoginFlowDelegate {}
extension AppCordinator: RegisterFlowDelegate {}
