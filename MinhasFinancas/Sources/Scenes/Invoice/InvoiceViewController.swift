//
//  Untitled.swift
//  MinhasFinancas
//
//  Created by edson lima on 13/02/26.
//

import AVFoundation
import Foundation
import Lottie
import Supabase
import UIKit

class InvoiceViewController: UIViewController {

    private let incomeView = InvoiceView()
    private let viewModel: InvoiceViewModel
    private let authViewModel = AuthViewModel()
    private var picker = UIImagePickerController()

    weak var invoiceDelegate: InvoiceFlowDelegate?

    private var currentInvoices: [Invoice] = []

    private let invoiceType: InvoiceType?

    private var isLoadingData: Bool = true

    init(invoiceType: InvoiceType, invoiceDelegate: InvoiceFlowDelegate) {

        self.invoiceType = invoiceType

        self.invoiceDelegate = invoiceDelegate

        self.viewModel = InvoiceViewModel(invoiceType: invoiceType)

        super.init(nibName: nil, bundle: nil)

        if self.invoiceType == .income {
            incomeView.titleLabel.text = "Receitas"
            incomeView.incomeButton.setTitle("+ Receitas", for: .normal)
        } else {
            incomeView.titleLabel.text = "Despesas"
            incomeView.incomeButton.setTitle("+ Despesas", for: .normal)
            incomeView.contentTopCardView.backgroundColor = Colors.red700
            incomeView.contentInsideTopCardView.backgroundColor = Colors.red800
            incomeView.incomeButton.backgroundColor = Colors.red600
            incomeView.incomeButton.setTitleColor(Colors.red400, for: .normal)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBinds()
        incomeView.startLoadingShimmer()
        viewModel.getMonth()
        setupDelegates()
        setupObservers()
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {

            if let image = await UserDefaultsManager.getImageProfile() {
                self.incomeView.imageProfile.image = image
            }
        }

    }

    private func setupBinds() {

        viewModel.onMonthSelected = { [weak self] index in

            self?.isLoadingData = true

            self?.incomeView.startLoadingShimmer()

            self?.scrollToMonth(at: index)
        }

        viewModel.onInvoicesUpdated = { [weak self] in

            Task { @MainActor in

                guard let self = self else { return }

                self.isLoadingData = false

                self.incomeView.valueIncomeLable.text = self.viewModel.getTotal()

                let isEmpty = self.viewModel.currentInvoices.isEmpty
                self.incomeView.tableView.isHidden = isEmpty
                self.incomeView.titleInvoicesEmpty.isHidden = !isEmpty

                self.incomeView.tableView.reloadData()
                self.incomeView.stopLoadingShimmer()
            }
        }

        incomeView.onTapSelecImageProfile = { [weak self] in

            let alert = UIAlertController(title: "Selecionar foto", message: nil, preferredStyle: .alert)

            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { _ in
                self?.openCamera()
            }

            let photoLibraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { _ in
                self?.openGallery()
            }

            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)

            alert.addAction(cameraAction)
            alert.addAction(photoLibraryAction)
            alert.addAction(cancelAction)

            self?.present(alert, animated: true)
        }

        incomeView.onTapLogout = { [weak self] in

            let alert = UIAlertController(title: "Sair", message: "Deseja realmente sair?", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            let logoutAction = UIAlertAction(title: "Sair", style: .destructive) { _ in

                Task {
                    try await self?.authViewModel.signOut()

                    UserDefaultsManager.desableFaceId()

                    self?.invoiceDelegate?.navigateToLogin()
                }

            }

            alert.addAction(cancelAction)
            alert.addAction(logoutAction)

            self?.present(alert, animated: true)

        }

    }

    private func scrollToMonth(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)

        DispatchQueue.main.async {
            self.incomeView.tabsCollectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: true
            )

            //Seleciona o item, ativa o 'isSelected' da cell
            self.incomeView.tabsCollectionView.selectItem(
                at: indexPath,
                animated: true,
                scrollPosition: .centeredHorizontally
            )
        }
    }

    //MARK: observers
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshData),
            name: NSNotification.Name("invoiceSaved"),
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onInvoiceCreated),
            name: NSNotification.Name("invoiceCreated"),
            object: nil
        )
    }

    @objc
    private func refreshData() {

        guard let month = self.viewModel.selectedDate else { return }

        self.viewModel.getMonth(month: month)
    }

    @objc
    private func onInvoiceCreated() {

        //obs se nao verificar se a View atual ja ta em bacground executada, toda vez que trocar de aba vai fica chamando esse metodo e o success fica aparecendo
        guard self.viewIfLoaded?.window != nil else {
            print("onInvoiceCreated ignorado pois a aba está em background")
            return
        }

        print("onInvoiceCreated")
        self.incomeView.lottieLoading.isHidden = false
        self.incomeView.lottieLoading.play { [weak self] finished in

            if finished {
                self?.incomeView.lottieLoading.isHidden = true
                self?.incomeView.lottieLoading.stop()
            }

        }
    }

    override func loadView() {
        super.loadView()
        self.view = incomeView

    }

    private func setupDelegates() {
        incomeView.tabsCollectionView.delegate = self
        incomeView.tabsCollectionView.dataSource = self
        incomeView.tabsCollectionView.register(
            MonthCollectionViewCell.self,
            forCellWithReuseIdentifier: MonthCollectionViewCell.identifier
        )

        incomeView.tableView.dataSource = self
        incomeView.tableView.delegate = self
        incomeView.tableView.register(IncomeTableViewCell.self, forCellReuseIdentifier: IncomeTableViewCell.identifier)

        incomeView.delegate = self

        self.picker.delegate = self
        self.picker.allowsEditing = true
    }

    private func didPressEditCell(indexPath: IndexPath) {

        let invoiceSelected = self.viewModel.currentInvoices[indexPath.row]

        self.openBottomSheet(invoice: invoiceSelected)

    }

    private func didSwipeToDeleteCell(indexPath: IndexPath) {

        let invoiceSelected = self.viewModel.currentInvoices[indexPath.row]

        let alert = UIAlertController(
            title: "Deseja excluir?",
            message: "Tem certeza que deseja remover essa parcela?",
            preferredStyle: .alert
        )

        if invoiceSelected.installmentId != nil {

            let allAction = UIAlertAction(title: "Todas", style: .default) { [weak self] _ in

                guard let self = self else { return }

                guard let installmentId = invoiceSelected.installmentId else {
                    return
                }

                self.viewModel.currentInvoices.remove(at: indexPath.row)

                self.incomeView.tableView.deleteRows(at: [indexPath], with: .fade)

                Task {

                    await self.viewModel.deleteAll(installmentId: installmentId)

                    self.incomeView.valueIncomeLable.text = self.viewModel.getTotal()
                }
            }

            alert.addAction(allAction)
        }

        let singleTitle = invoiceSelected.installmentId != nil ? "Apenas esta" : "Sim"

        let singleAction = UIAlertAction(title: singleTitle, style: .default) { [weak self] _ in
            guard let self = self else { return }

            guard let invoiceId = invoiceSelected.id else {
                return
            }

            self.viewModel.currentInvoices.remove(at: indexPath.row)

            self.incomeView.tableView.deleteRows(at: [indexPath], with: .fade)

            Task {

                await self.viewModel.deleteSingle(invoiceId: invoiceId)

                self.incomeView.valueIncomeLable.text = self.viewModel.getTotal()
            }
        }

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)

        alert.addAction(singleAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)

    }

    private func openGallery() {
        self.picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }

    private func openCamera() {

        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                self.picker.sourceType = .camera
                self.picker.showsCameraControls = true
                self.present(self.picker, animated: true)
            } else {
                AVCaptureDevice.requestAccess(
                    for: .video,
                    completionHandler: { granted in

                        if granted {
                            DispatchQueue.main.async {
                                self.picker.sourceType = .camera
                                self.picker.showsCameraControls = true
                                self.present(self.picker, animated: true)
                            }
                        } else {

                            DispatchQueue.main.async {
                                let alert = UIAlertController(
                                    title: "Habilite a camera",
                                    message:
                                        "Habilite a permissão de uso da camera nas configurações do seu dispositivo, para usar essa função",
                                    preferredStyle: .alert
                                )

                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))

                                self.present(alert, animated: true)
                            }

                        }

                    }
                )
            }

        } else {
            print("Camera indisponivel")
        }

    }

}

extension InvoiceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 70, height: 60)
    }
}

extension InvoiceViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: MonthCollectionViewCell.identifier, for: indexPath)
            as! MonthCollectionViewCell

        cell.labelMonth.text = viewModel.titleForMonth(at: indexPath.item)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dateSelected = viewModel.months[indexPath.item]
        viewModel.getMonth(month: dateSelected)
    }

}

extension InvoiceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
}

extension InvoiceViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //linhas fantasmas
        if isLoadingData {
            return 5
        }

        return self.viewModel.currentInvoices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell =
            tableView.dequeueReusableCell(withIdentifier: IncomeTableViewCell.identifier, for: indexPath) as! IncomeTableViewCell
        cell.selectionStyle = .none

        if isLoadingData {
            cell.startLoadingShimmer()
            return cell
        }

        cell.stopLoadingShimmer()

        let invoice = self.viewModel.currentInvoices[indexPath.row]

        cell.configure(invoice: invoice)

        cell.onLongPress = { [weak self] in
            guard let self = self else { return }

            self.didPressEditCell(indexPath: indexPath)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration?
    {

        let deleteAction = UIContextualAction(style: .destructive, title: "Deletar") {
            [weak self] (action, view, completionHandler) in

            self?.didSwipeToDeleteCell(indexPath: indexPath)

            // Avisa a tabela que a ação terminou
            completionHandler(true)
        }

        deleteAction.image = UIImage(systemName: "trash")

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

}

extension InvoiceViewController: BottomSheetFormDelegate {

    func openBottomSheet() {
        let bottomSheetFormVC = BottomSheetFormController(invoiceType: self.invoiceType!)
        present(bottomSheetFormVC, animated: true)

    }

    func openBottomSheet(invoice: Invoice) {
        let bottomSheetFormVC = BottomSheetFormController(invoiceType: self.invoiceType!, invoice: invoice)

        present(bottomSheetFormVC, animated: true)
    }

}

extension InvoiceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {

        var selectedImage: UIImage?

        if let imageEdit = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = imageEdit

        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = originalImage
        }

        if let image = selectedImage {
            Task {
                self.incomeView.imageProfile.image = image
                await UserDefaultsManager.setImageProfile(image: image)
            }
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

}
