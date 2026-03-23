//
//  IncomeView.swift
//  MinhasFinancas
//
//  Created by edson lima on 19/02/26.
//

import Lottie
import Foundation
import UIKit

class InvoiceView: UIView {

    weak var delegate: BottomSheetFormDelegate?

    var onTapSelecImageProfile: (() -> Void)?
    var onTapLogout: (() -> Void)?

    lazy var contentTopCardView = {
        let content = UIView()
        content.backgroundColor = Colors.green700
        content.heightAnchor.constraint(equalToConstant: 360).isActive = true
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()

    lazy var contentInsideTopCardView = {
        let content = UIView()
        content.backgroundColor = Colors.green800
        content.layer.cornerRadius = 16
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()

    lazy var contentMainCardView = {
        let content = UIView()
        content.layer.cornerRadius = 16
        content.layer.masksToBounds = true
        content.backgroundColor = .white
        content.clipsToBounds = true
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()

    lazy var mainStack = {
        let stack = UIStackView(arrangedSubviews: [
            contentTopCardView,
            contentMainCardView,
        ])
        stack.axis = .vertical
        stack.spacing = -20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var imageProfile = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 22
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.heightAnchor.constraint(equalToConstant: 44).isActive = true
        image.widthAnchor.constraint(equalToConstant: 44).isActive = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var titleLabel = {
        let label = UILabel()
        label.text = "Receitas"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var bellNotification = {
        let button = UIButton()
        button.setImage(UIImage(named: "logout2"), for: .normal)
        button.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var totalIncomeLable = {
        let label = UILabel()
        label.text = "Total"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var valueIncomeLable = {
        let label = UILabel()
        label.text = "R$ 0,00"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var valueIncomeShimmer: ShimmerView = {
        let shimmer = ShimmerView()
        shimmer.alpha = 0
        shimmer.translatesAutoresizingMaskIntoConstraints = false
        return shimmer
    }()

    lazy var incomeButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Receitas", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = Colors.green600
        button.setTitleColor(Colors.green400, for: .normal)
        button.layer.cornerRadius = 24
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(didTapOpenBottomSheet), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var totalIncomeStack = {
        let stack = UIStackView(arrangedSubviews: [
            totalIncomeLable,
            valueIncomeLable,
            incomeButton,
        ])
        stack.axis = .vertical
        stack.spacing = 28
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var tabsCollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    lazy var tableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    lazy var titleInvoicesEmpty = {
        let title = UILabel()
        title.text = "Nenhuma registro encontrado"
        title.textColor = Colors.gray700
        title.isHidden = true
        title.font = .systemFont(ofSize: 18, weight: .medium)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    lazy var lottieLoading = {
       let lottie = LottieAnimationView(name: "success")
        lottie.loopMode = .playOnce
        lottie.isHidden = true
        lottie.translatesAutoresizingMaskIntoConstraints = false
        return lottie
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()

        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        
        addSubview(mainStack)

        contentTopCardView.addSubview(imageProfile)
        contentTopCardView.addSubview(titleLabel)
        contentTopCardView.addSubview(bellNotification)
        contentTopCardView.addSubview(contentInsideTopCardView)
        contentInsideTopCardView.addSubview(totalIncomeStack)
        contentInsideTopCardView.addSubview(valueIncomeShimmer)

        contentMainCardView.addSubview(tabsCollectionView)
        contentMainCardView.addSubview(tableView)
        contentMainCardView.addSubview(titleInvoicesEmpty)
        
        addSubview(lottieLoading)
    
        setupConstraints()
    }

    private func setupActions() {
        self.imageProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSelectImage)))
    }

    @objc
    private func didTapSelectImage() {
        self.onTapSelecImageProfile?()
    }

    @objc
    private func didTapOpenBottomSheet() {
        self.delegate?.openBottomSheet()
    }

    @objc
    private func didTapLogout() {
        onTapLogout?()
    }

    func startLoadingShimmer() {
        valueIncomeLable.alpha = 0  //esconde o valor padrão R$0,00
        valueIncomeShimmer.alpha = 1  // Mostra o Shimmer
    }

    func stopLoadingShimmer() {
        UIView.animate(withDuration: 0.3) {
            self.valueIncomeShimmer.alpha = 0
            self.valueIncomeLable.alpha = 1
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),

            imageProfile.topAnchor.constraint(equalTo: contentTopCardView.topAnchor, constant: 62),
            imageProfile.leadingAnchor.constraint(equalTo: contentTopCardView.leadingAnchor, constant: 24),

            titleLabel.centerYAnchor.constraint(equalTo: imageProfile.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentTopCardView.centerXAnchor),

            bellNotification.centerYAnchor.constraint(equalTo: imageProfile.centerYAnchor),
            bellNotification.trailingAnchor.constraint(equalTo: contentTopCardView.trailingAnchor, constant: -24),

            contentInsideTopCardView.topAnchor.constraint(equalTo: imageProfile.bottomAnchor, constant: 20),
            contentInsideTopCardView.leadingAnchor.constraint(equalTo: contentTopCardView.leadingAnchor, constant: 24),
            contentInsideTopCardView.trailingAnchor.constraint(equalTo: contentTopCardView.trailingAnchor, constant: -24),
            contentInsideTopCardView.bottomAnchor.constraint(equalTo: contentTopCardView.bottomAnchor, constant: -40),

            totalIncomeStack.centerYAnchor.constraint(equalTo: contentInsideTopCardView.centerYAnchor),
            totalIncomeStack.centerXAnchor.constraint(equalTo: contentInsideTopCardView.centerXAnchor),

            tabsCollectionView.topAnchor.constraint(equalTo: contentMainCardView.topAnchor, constant: 24),
            tabsCollectionView.trailingAnchor.constraint(equalTo: contentMainCardView.trailingAnchor, constant: -24),
            tabsCollectionView.leadingAnchor.constraint(equalTo: contentMainCardView.leadingAnchor, constant: 24),
            tabsCollectionView.heightAnchor.constraint(equalToConstant: 60),

            tableView.topAnchor.constraint(equalTo: tabsCollectionView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: contentMainCardView.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: contentMainCardView.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: contentMainCardView.bottomAnchor),

            titleInvoicesEmpty.centerXAnchor.constraint(equalTo: contentMainCardView.centerXAnchor),
            titleInvoicesEmpty.centerYAnchor.constraint(equalTo: contentMainCardView.centerYAnchor),
            
            lottieLoading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            lottieLoading.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lottieLoading.widthAnchor.constraint(equalToConstant: 100),
            lottieLoading.heightAnchor.constraint(equalToConstant: 100),

            //Coloca o shimmer valueIncomeLable
            valueIncomeShimmer.centerXAnchor.constraint(equalTo: valueIncomeLable.centerXAnchor),
            valueIncomeShimmer.centerYAnchor.constraint(equalTo: valueIncomeLable.centerYAnchor),
            valueIncomeShimmer.widthAnchor.constraint(equalToConstant: 140),
            valueIncomeShimmer.heightAnchor.constraint(equalToConstant: 34),
            
        ])
    }
}
