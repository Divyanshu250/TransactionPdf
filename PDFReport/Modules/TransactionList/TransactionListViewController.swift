//
//  TransactionListViewController.swift
//  PDFReport
//
//  Created by Techahead on 01/08/25.
//  

import UIKit

// ***********************************************************//
// MARK: - VIEWCONTROLLER INPUT PROTOCOLS
// ***********************************************************//

protocol TransactionListViewInputs: AnyObject{
    func configure(entities: TransactionListEntities)
    func reloadTableView()
    func showPdfOptions(url: URL?)
    func showToasMessage(msg: String?)
}

// ***********************************************************//
// MARK: - VIEWCONTROLLER OUTPUT PROTOCOLS
// ***********************************************************//

protocol TransactionListViewOutputs : AnyObject{
    func initializeView()
    func updateDataAndStartSearch(filterData: Bool?, searchText: String?)
    func pdfBtnPressed()
}

// ***********************************************************//
// MARK: - VIEWCONTROLLER
// ***********************************************************//

class TransactionListViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var generatePdfBtnView: UIView!
    @IBOutlet weak var generatePdfBtn: UIButton!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchIconImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableViewAndSearchViewSeparatorView: UIView!
    @IBOutlet weak var transactionTableView: UITableView!
    
    // MARK: Variables
    internal var presenter: TransactionListViewOutputs?
    internal var tblViewDataSource : TableViewItemDataSource?
    internal var collViewDataSource: CollectionViewItemDataSource?
    private var debounceWorkItem: DispatchWorkItem?
    private let loader = UIActivityIndicatorView(style: .large)
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.initializeView()
        initialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    // MARK: - Initial UI Setup
    func initialSetUp(){
        fontSetUp()
        textSetUp()
        colorSetUp()
        viewSetUp()
        tableViewSetUp()
        configureSearchTextField()
    }
    
    func fontSetUp(){
        historyLabel.font = UIFont.customFont(family: .monaSansSemiBold, size: .size24)
        generatePdfBtn.titleLabel?.font = UIFont.customFont(family: .monaSansSemiBold, size: .size16)
        searchTextField.font = UIFont.customFont(family: .monaSansMedium, size: .size20)
    }
    
    func textSetUp(){
        historyLabel.text = HistoryScreenText.historyText
        generatePdfBtn.setTitle(HistoryScreenText.myStatementText, for: .normal)
        searchTextField.placeholder = HistoryScreenText.searchTransactionText
    }
        
    func colorSetUp(){
        historyLabel.textColor = Colors.blackColor.color
        generatePdfBtn.setTitleColor(Colors.blackColor.color, for: .normal)
        searchTextField.textColor = Colors.blackColor.color
    }
    
    func viewSetUp(){
        generatePdfBtnView.layer.cornerRadius = 20
        generatePdfBtnView.layer.borderWidth = 1
        generatePdfBtnView.layer.borderColor = Colors.greyColor.color.cgColor
        searchBarView.layer.cornerRadius = 30
        searchBarView.backgroundColor = Colors.lightGreyColor.color
        tableViewAndSearchViewSeparatorView.backgroundColor = Colors.greyColor.color
    }
    
    func tableViewSetUp(){
        transactionTableView.dataSource = self
        transactionTableView.register(UINib(nibName: "TransactionListTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionListTableViewCell")
        transactionTableView.register(ShimmerCellTableViewCell.self, forCellReuseIdentifier: "ShimmerCellTableViewCell")
        transactionTableView.separatorStyle = .none
    }
    
    private func configureSearchTextField() {
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)

        // Done button on keyboard
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [doneButton]
        searchTextField.inputAccessoryView = toolbar
    }

    @objc private func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
    
    //MARK: IBActions
    @IBAction func generatePdfBtnAction(_ sender: UIButton){
        loader.center = self.view.center
        loader.color = Colors.blackColor.color
        loader.startAnimating()
        self.view.addSubview(loader)
        presenter?.pdfBtnPressed()
    }
}

// ***********************************************************//
// MARK: - INPUT PROTOCOL DEFINITION
// ***********************************************************//

extension TransactionListViewController: TransactionListViewInputs{
    
    func configure(entities: TransactionListEntities){
        
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.transactionTableView.reloadData()
        }
    }
    
    func showPdfOptions(url: URL?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.loader.stopAnimating()
            self.loader.removeFromSuperview()
            
            guard let url = url else {
                self.showToasMessage(msg: "Failed to generate PDF.")
                return
            }
            
            let protectAction = UIAlertAction(title: "Protect & Share", style: .default) { [weak self] _ in
                self?.askPasswordAndEncrypt(pdfURL: url)
            }
            
            let previewAction = UIAlertAction(title: "Preview", style: .default) { [weak self] _ in
                guard let self = self else { return }
                let docVC = UIDocumentInteractionController(url: url)
                docVC.delegate = self
                docVC.presentPreview(animated: true)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            let alert = UIAlertController(title: "Export PDF", message: nil, preferredStyle: .actionSheet)
            alert.addAction(protectAction)
            alert.addAction(previewAction)
            alert.addAction(cancel)
            
            // Optional delay for smoothness (can be removed)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.present(alert, animated: true)
            }
        }
    }

    func showToasMessage(msg: String?) {
        showToast(message: msg ?? "")
    }
}

// ***********************************************************//
// MARK: - VIEWABLE PROTOCOL DEFINITION
// ***********************************************************//

extension TransactionListViewController: Viewable {}


// ***********************************************************//
// MARK: - TABLEVIEW METHODS
// ***********************************************************//

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tblViewDataSource?.numberOfItems(tableView : tableView, section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tblViewDataSource?.itemCell(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }
}


// ***********************************************************//
// MARK: - COLLECTIONVIEW METHODS
// ***********************************************************//

extension TransactionListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collViewDataSource?.numberOfItems(collView: collectionView, section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collViewDataSource?.itemCell(collView: collectionView, indexPath: indexPath) ?? UICollectionViewCell()
    }
}

extension TransactionListViewController: UITextFieldDelegate{
    
    @objc private func searchTextChanged(_ textField: UITextField) {
        debounceWorkItem?.cancel()
        let text = textField.text ?? ""
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            if text.count >= 3 {
                presenter?.updateDataAndStartSearch(filterData: true, searchText: text)
            } else {
                presenter?.updateDataAndStartSearch(filterData: false, searchText: nil)
            }
        }
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem) // 500ms debounce
    }
}

extension TransactionListViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func askPasswordAndEncrypt(pdfURL: URL) {
        let alert = UIAlertController(title: "Set Password", message: "Enter a password to protect the PDF", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "Password"
            tf.isSecureTextEntry = true
        }

        let protectAction = UIAlertAction(title: "Protect & Share", style: .default) { [weak self] _ in
            guard let password = alert.textFields?.first?.text, !password.isEmpty else {
                self?.showToasMessage(msg: "Password cannot be empty.")
                return
            }

            guard let encryptedURL = PDFGenerator.encryptPDF(at: pdfURL, withPassword: password) else {
                self?.showToasMessage(msg: "Encryption failed.")
                return
            }

            self?.sharePDF(at: encryptedURL)
        }

        alert.addAction(protectAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func sharePDF(at url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.assignToContact]
        self.present(activityVC, animated: true)
    }
}
