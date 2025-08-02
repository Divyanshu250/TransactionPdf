//
//  TransactionListInteractor.swift
//  PDFReport
//
//  Created by Techahead on 01/08/25.
//  

import Foundation

// ***********************************************************//
// MARK: - INTERACTOR PROTOCOLS
// ***********************************************************//

protocol TransactionListInteractorOutputs: AnyObject {
    func didFetchTransactions(_ transactions: [TransactionModel]?, isSuccess: Bool, error: String?)
}

// ***********************************************************//
// MARK: - INTERACTOR METHODS
// ***********************************************************//
final class TransactionListInteractor: Interactorable{
    weak var presenter: TransactionListInteractorOutputs?
    
    func fetchTransactions() {
        NetworkManager.shared.request(
            urlString: "https://iosserver.free.beeceptor.com/history", useCache: true
        ) { [weak self] (result: Result<[TransactionModel], NetworkError>) in
            switch result {
            case .success(let transactions):
                let saved = CoreDataManager.shared.fetchTransactions()
                let sortedSaved = saved.sorted { ($0.dateObject ?? Date.distantPast) < ($1.dateObject ?? Date.distantPast) }
                let sortedIncoming = transactions.sorted { ($0.dateObject ?? Date.distantPast) < ($1.dateObject ?? Date.distantPast) }
                if sortedSaved != sortedIncoming {
                    CoreDataManager.shared.clearTransactions()
                    CoreDataManager.shared.saveTransactions(transactions)
                }
                self?.presenter?.didFetchTransactions(transactions, isSuccess: true, error: nil)
            case .failure(let error):
                switch error {
                case .offline:
                    print("⚠️ Offline: Showing cached data")
                    let cached = CoreDataManager.shared.fetchTransactions()
                    self?.presenter?.didFetchTransactions(cached, isSuccess: true, error: nil)
                default:
                    print("❌ API Error: \(error.localizedDescription)")
                    let cached = CoreDataManager.shared.fetchTransactions()
                    print("⚠️ Showing cached data",cached)
                    self?.presenter?.didFetchTransactions(cached, isSuccess: false, error: error.localizedDescription)
                }
            }
        }
    }
    
}
