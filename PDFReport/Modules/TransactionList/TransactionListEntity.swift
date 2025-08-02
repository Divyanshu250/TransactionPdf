//
//  TransactionListEntity.swift
//  PDFReport
//
//  Created by Techahead on 01/08/25.
//

import Foundation

struct TransactionListEntryEntity {
    
}

// MARK: - Main Entity Container
final class TransactionListEntities {
    let entryEntity: TransactionListEntryEntity
    var transactionModel: [TransactionModel]?
    var filteredTransactions: [TransactionModel]?
    var isDataFetchingFromApi: Bool = false // Prefer Bool default over optional
    
    init(entryEntity: TransactionListEntryEntity) {
        self.entryEntity = entryEntity
    }
}

// MARK: - Transaction Model
struct TransactionModel: Codable, Equatable {
    let transactionDate: String?
    let transactionCategory: String?
    let transactionID: String?
    let status: String?
    let amount: String?
    let transactionType: String?
    
    var formattedDate: String {
        guard let date = DateFormatters.iso8601WithMillis.date(from: transactionDate ?? "") else {
            return transactionDate ?? ""
        }
        return DateFormatters.displayFormatter.string(from: date)
    }
    
    var dateObject: Date? {
        return DateFormatters.iso8601WithMillis.date(from: transactionDate ?? "")
    }
}
