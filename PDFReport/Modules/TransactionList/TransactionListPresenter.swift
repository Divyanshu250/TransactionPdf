//
//  TransactionListPresenter.swift
//  PDFReport
//
//  Created by Techahead on 01/08/25.
//  
//

import Foundation

// ***********************************************************//
// MARK: - PRESENTER DEPENDENCIES
// ***********************************************************//

typealias TransactionListPresenterDependencies = (
    interactor: TransactionListInteractor,
    router: TransactionListRouterOutput
)

// ***********************************************************//
// MARK: - PRESENTER DEPENDENCIES INIT
// ***********************************************************//

final class TransactionListPresenter: Presenterable {
    
    internal var entities: TransactionListEntities
    private weak var view: TransactionListViewInputs!
    let dependencies: TransactionListPresenterDependencies

    init(entities: TransactionListEntities,
         view: TransactionListViewInputs,
         dependencies: TransactionListPresenterDependencies)
    {
        self.view = view
        self.entities = entities
        self.dependencies = dependencies
    }
}

// ***********************************************************//
// MARK: - VIEWCONTROLLER OUTPUT PROTOCOL METHODS
// ***********************************************************//

extension TransactionListPresenter: TransactionListViewOutputs{
    
    func pdfBtnPressed() {
        PDFGenerator.generate(transactions: entities.transactionModel ?? []) { [weak self] url in
            guard let url = url else { return }
            self?.view.showPdfOptions(url: url)
        }
    }
    
    
    func updateDataAndStartSearch(filterData: Bool?, searchText: String?) {
        if filterData ?? false{
            entities.filteredTransactions = entities.transactionModel?.filter {
                ($0.transactionCategory ?? "").localizedCaseInsensitiveContains(searchText ?? "")
            }
        }else{
            entities.filteredTransactions = entities.transactionModel
        }
        view.reloadTableView()
    }
    
    
    func initializeView() {
        print("initializeView")
        entities.isDataFetchingFromApi = true
        view.configure(entities: entities)
        dependencies.interactor.fetchTransactions()
    }
}

// ***********************************************************//
// MARK: - INTERACTOR OUTPUT PROTOCOL METHODS
// ***********************************************************//

extension TransactionListPresenter: TransactionListInteractorOutputs{
    
    func didFetchTransactions(_ transactions: [TransactionModel]?, isSuccess: Bool, error: String?) {
        entities.isDataFetchingFromApi = false
        let validTransactions = transactions ?? []
        entities.transactionModel = validTransactions
        entities.filteredTransactions = validTransactions
        view.reloadTableView()
        
        if !isSuccess, let error = error {
            view.showToasMessage(msg: error)
        }
    }
    
}

// ***********************************************************//
// MARK: - TABLEVIEW OUTPUT PROTOCOL METHODS
// ***********************************************************//

extension TransactionListPresenter : TransactionListTblViewDataSourceOutputs{
    
}

// ***********************************************************//
// MARK: - COLLECTIONVIEW OUTPUT PROTOCOL METHODS
// ***********************************************************//

extension TransactionListPresenter : TransactionListCollViewDataSourceOutputs{
    
}
