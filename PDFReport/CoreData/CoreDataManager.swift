//
//  CoreDataManager.swift
//  PDFReport
//
//  Created by Divyanshu Jadon on 02/08/25.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        guard Thread.isMainThread else {
            fatalError("Persistent container must be initialized on the main thread.")
        }
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }()
    
    var context: NSManagedObjectContext {
        guard Thread.isMainThread else {
            var result: NSManagedObjectContext!
            DispatchQueue.main.sync {
                result = self.persistentContainer.viewContext
            }
            return result
        }
        return persistentContainer.viewContext
    }
    
    func saveTransactions(_ transactions: [TransactionModel]) {
        DispatchQueue.main.async {
            for item in transactions {
                let entity = CDTransaction(context: self.context)
                entity.transactionID = item.transactionID
                entity.transactionCategory = item.transactionCategory
                entity.transactionDate = item.transactionDate
                entity.status = item.status
                entity.amount = item.amount
                entity.transactionType = item.transactionType
                
                print("💾 Saving transaction: \(item.transactionID ?? "") | Date: \(item.transactionDate ?? "") | Amount: \(item.amount ?? "")")
            }
            
            do {
                try self.context.save()
                print("✅ All transactions saved to Core Data.")
            } catch {
                print("❌ Failed to save transactions: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchTransactions() -> [TransactionModel] {
        var models: [TransactionModel] = []
        let request: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            models = results.map {
                let model = TransactionModel(
                    transactionDate: $0.transactionDate ?? "",
                    transactionCategory: $0.transactionCategory ?? "",
                    transactionID: $0.transactionID ?? "",
                    status: $0.status ?? "",
                    amount: $0.amount ?? "",
                    transactionType: $0.transactionType ?? ""
                )
                print("📥 Fetched transaction: \(model.transactionID ?? "") | Date: \(model.transactionDate ?? "") | Amount: \(model.amount ?? "")")
                return model
            }
        } catch {
            print("❌ Failed to fetch transactions: \(error.localizedDescription)")
        }
        
        return models
    }
    
    func clearTransactions() {
        DispatchQueue.main.async {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDTransaction.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try self.context.execute(deleteRequest)
                try self.context.save()
                print("🗑️ Successfully cleared all transactions from Core Data.")
            } catch {
                print("❌ Failed to clear transactions: \(error.localizedDescription)")
            }
        }
    }
}
