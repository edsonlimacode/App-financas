//
//  TabBarViewController.swift
//  MinhasFinancas
//
//  Created by edson lima on 19/02/26.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {

    weak var invoiceDelegate: InvoiceFlowDelegate?

    init(invoiceDelegate: InvoiceFlowDelegate?) {

        self.invoiceDelegate = invoiceDelegate

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }

    private func setupTabBar() {
        
        self.tabBar.tintColor = Colors.gray700
        self.tabBar.unselectedItemTintColor = Colors.gray700
        
        let income = UINavigationController(
            rootViewController:
                InvoiceViewController(invoiceType: .income, invoiceDelegate: self.invoiceDelegate!)
        )
        
        let expense = UINavigationController(
            rootViewController: InvoiceViewController(invoiceType: .expense, invoiceDelegate: self.invoiceDelegate!)
        )

        let icomeIcon = UIImage(named: "icome-menu-icon")?.withRenderingMode(.alwaysOriginal)
        let expenseIcon = UIImage(named: "expense-menu-icon")?.withRenderingMode(.alwaysOriginal)

        income.tabBarItem.image = icomeIcon
        income.tabBarItem.title = "Receitas"

        expense.tabBarItem.image = expenseIcon
        expense.tabBarItem.title = "Despesas"

        self.setViewControllers([income, expense], animated: false)
    }
}
