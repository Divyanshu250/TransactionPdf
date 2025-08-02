//
//  TransactionListRouter.swift
//  PDFReport
//
//  Created by Techahead on 01/08/25.
//  

import Foundation
import UIKit

// ***********************************************************//
// MARK: - ROUTER INPUT METHODS
// ***********************************************************//

struct TransactionListRouterInput{
    private func view(entryEntity : TransactionListEntryEntity) -> TransactionListViewController {
        let view = UIStoryboard.init(name: "Transactions", bundle: Bundle.main).instantiateViewController(withIdentifier: TransactionListViewController.className) as! TransactionListViewController
        let interactor = TransactionListInteractor()
        let dependencies = TransactionListPresenterDependencies(interactor: interactor, router: TransactionListRouterOutput(view))
        let presenter = TransactionListPresenter(entities: TransactionListEntities(entryEntity: entryEntity), view: view, dependencies: dependencies)
        view.presenter = presenter
        view.tblViewDataSource = TransactionListTblViewDataSource(entities: presenter.entities, presenter: presenter)
        view.collViewDataSource = TransactionListCollViewDataSource(entities: presenter.entities, presenter: presenter)
        interactor.presenter = presenter
        return view
    }

    func push(from: Viewable, entryEntity: TransactionListEntryEntity) {
        let view = self.view(entryEntity : entryEntity)
        from.push(view, animated: true)
    }

    func present(from: Viewable, entryEntity: TransactionListEntryEntity) {
        let nav = UINavigationController(rootViewController: view(entryEntity: entryEntity))
        from.present(nav, animated: true)
    }
    
    func getView(entryEntity: TransactionListEntryEntity) -> TransactionListViewController{
        return self.view(entryEntity : entryEntity)
    }
}

// ***********************************************************//
// MARK: - ROUTER OUTPUT METHODS
// ***********************************************************//

final class TransactionListRouterOutput: Routerable {

    private(set) weak var view: Viewable!

    init(_ view: Viewable) {
        self.view = view
    }
    
    func navigate(){
        
    }
}
