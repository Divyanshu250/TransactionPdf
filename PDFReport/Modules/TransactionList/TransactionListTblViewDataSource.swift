//
//  TransactionListTblViewDataSource.swift
//  PDFReport
//
//  Created by Techahead on 01/08/25.
//  

import Foundation
import UIKit

// ***********************************************************//
// MARK: - TABLEVIEW OUTPUT PROTOCOLS
// ***********************************************************//

protocol TransactionListTblViewDataSourceOutputs: AnyObject {
}

// ***********************************************************//
// MARK: - TABLEVIEW PROTOCOL METHODS
// ***********************************************************//

final class TransactionListTblViewDataSource: TableViewItemDataSource {
    
    private weak var entities: TransactionListEntities!
    private weak var presenter: TransactionListTblViewDataSourceOutputs?
    
    init(entities: TransactionListEntities, presenter: TransactionListTblViewDataSourceOutputs) {
        self.entities = entities
        self.presenter = presenter
    }
    
    func numberOfItems(tableView: UITableView, section: Int) -> Int {
        return entities.isDataFetchingFromApi ? 3 : entities.filteredTransactions?.count ?? 0
    }
        
    func itemCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if entities.isDataFetchingFromApi{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ShimmerCellTableViewCell", for: indexPath) as? ShimmerCellTableViewCell{
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionListTableViewCell", for: indexPath) as? TransactionListTableViewCell{
                cell.configureCell(data: entities.filteredTransactions?[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func didSelect(tableView: UITableView, indexPath: IndexPath) {
        
    }
}
