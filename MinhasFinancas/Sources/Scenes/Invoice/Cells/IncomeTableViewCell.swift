//
//  IncomeTableViewCell.swift
//  MinhasFinancas
//
//  Created by edson lima on 24/02/26.
//

import Foundation
import UIKit

class IncomeTableViewCell: UITableViewCell {

    static let identifier: String = "incomeTableViewCell"

    var onLongPress: (() -> Void)?

    private lazy var contentIcon = {
        let view = UIView()
        view.backgroundColor = Colors.gray500
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var iconView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = Colors.gray700
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var totalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = Colors.gray750
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var dateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = Colors.gray750
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: shimmers
    private lazy var iconShimmer: ShimmerView = {
        let view = ShimmerView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleShimmer: ShimmerView = {
        let view = ShimmerView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var totalShimmer: ShimmerView = {
        let view = ShimmerView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear
        self.layer.cornerRadius = 16
        setupGesture()
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }

    private func setupViews() {
        addSubview(contentIcon)
        contentIcon.addSubview(iconView)

        addSubview(titleLabel)
        addSubview(totalTitleLabel)
        addSubview(dateTitleLabel)

        addSubview(iconShimmer)
        addSubview(titleShimmer)
        addSubview(totalShimmer)

        setupConstraints()
    }

    func configure(invoice: Invoice) {

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "BRL"
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2

        let image = invoice.type == "income" ? UIImage(named: "income-icon") : UIImage(named: "outcome-icon")
        self.iconView.image = image

        titleLabel.text = invoice.description
        totalTitleLabel.text = numberFormatter.string(from: invoice.value as NSNumber)
        dateTitleLabel.text = invoice.dueDate
    }

    private func setupGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.contentView.addGestureRecognizer(gesture)
    }

    @objc
    private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            onLongPress?()
        }
    }

    func startLoadingShimmer() {
        // Esconde os conteúdos reais
        contentIcon.alpha = 0
        titleLabel.alpha = 0
        totalTitleLabel.alpha = 0
        dateTitleLabel.alpha = 0

        // Mostra os shimmers
        iconShimmer.alpha = 1
        titleShimmer.alpha = 1
        totalShimmer.alpha = 1

        // Desativa a interação durante o carregamento
        self.isUserInteractionEnabled = false
    }

    func stopLoadingShimmer() {
        UIView.animate(withDuration: 0.3) {
            self.contentIcon.alpha = 1
            self.titleLabel.alpha = 1
            self.totalTitleLabel.alpha = 1
            self.dateTitleLabel.alpha = 1

            self.iconShimmer.alpha = 0
            self.titleShimmer.alpha = 0
            self.totalShimmer.alpha = 0
        }
        self.isUserInteractionEnabled = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentIcon.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentIcon.heightAnchor.constraint(equalToConstant: 50),
            contentIcon.widthAnchor.constraint(equalToConstant: 50),

            iconView.centerXAnchor.constraint(equalTo: contentIcon.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: contentIcon.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentIcon.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),

            totalTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            totalTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            dateTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dateTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            // Shimmers - X e Y para ocupar o mesmo lugar
            iconShimmer.centerXAnchor.constraint(equalTo: contentIcon.centerXAnchor),
            iconShimmer.centerYAnchor.constraint(equalTo: contentIcon.centerYAnchor),
            iconShimmer.widthAnchor.constraint(equalTo: contentIcon.widthAnchor),
            iconShimmer.heightAnchor.constraint(equalTo: contentIcon.heightAnchor),

            titleShimmer.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            titleShimmer.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            titleShimmer.widthAnchor.constraint(equalToConstant: 120),  // Tamanho fixo para simular texto
            titleShimmer.heightAnchor.constraint(equalToConstant: 20),

            totalShimmer.centerXAnchor.constraint(equalTo: totalTitleLabel.centerXAnchor),
            totalShimmer.centerYAnchor.constraint(equalTo: totalTitleLabel.centerYAnchor),
            totalShimmer.widthAnchor.constraint(equalToConstant: 80),  // Tamanho fixo para simular valor
            totalShimmer.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

}
