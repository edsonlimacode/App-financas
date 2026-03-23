//
//  TabMonthViewCell.swift
//  MinhasFinancas
//
//  Created by edson lima on 20/02/26.
//

import Foundation
import UIKit

class MonthCollectionViewCell: UICollectionViewCell {

    static let identifier: String = "TabMonthViewCell"

    lazy var labelMonth = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.gray600
        view.layer.cornerRadius = 12
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override var isSelected: Bool {
        didSet {
            indicatorView.isHidden = !isSelected
            labelMonth.textColor = isSelected ? Colors.gray750 : Colors.gray800
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(labelMonth)
        addSubview(indicatorView)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelMonth.topAnchor.constraint(equalTo: self.topAnchor),
            labelMonth.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelMonth.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelMonth.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 2),
            indicatorView.widthAnchor.constraint(equalTo: labelMonth.widthAnchor, constant: 18),
        ])
    }
}
