//
//  TableViewItemDataSource.swift
//  PDFReport
//
//  Created by Divyanshu Jadon on 02/08/25.
//

import Foundation
import UIKit

protocol TableViewItemDataSource: AnyObject {
    func numberOfSections(tableView: UITableView) -> Int
    func numberOfItems(tableView: UITableView, section: Int) -> Int
    func itemCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func didSelect(tableView: UITableView, indexPath: IndexPath)
    func didDeSelect(tableView: UITableView, indexPath : IndexPath)
    func willDisplay(tableView: UITableView, indexPath : IndexPath)
    
    // New optional methods
    func titleForHeaderInSection(_ tableView: UITableView, section: Int) -> String?
    func titleForFooterInSection(_ tableView: UITableView, section: Int) -> String?
    func canEditRowAt(_ tableView: UITableView, indexPath: IndexPath) -> Bool
    func viewForHeaderInSection(_ tableView: UITableView, section: Int) -> UIView?
    func didEndDisplaying(tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath)
    func willDisplayHeaderView(_ tableView: UITableView, view: UIView, section: Int)
    func heightForRowAt(tableView: UITableView, indexPath: IndexPath) -> CGFloat
    func heightForHeaderInSection(_ tableView: UITableView, section: Int) -> CGFloat
    func heightForFooterInSection(_ tableView: UITableView, section: Int) -> CGFloat
    func commit(tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    func trailingSwipeActions(tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
}

extension TableViewItemDataSource{
    func numberOfSections(tableView: UITableView) -> Int{
        return 1
    }
    
    func didDeSelect(tableView: UITableView, indexPath : IndexPath){
        
    }
    
    func willDisplay(tableView: UITableView, indexPath : IndexPath){
        
    }
    
    func titleForHeaderInSection(_ tableView: UITableView, section: Int) -> String? {
        return nil
    }
    
    func titleForFooterInSection(_ tableView: UITableView, section: Int) -> String? {
        return nil
    }
    
    func canEditRowAt(_ tableView: UITableView, indexPath: IndexPath) -> Bool {
        return true
    }
    
    func viewForHeaderInSection(_ tableView: UITableView, section: Int) -> UIView? {
        return nil
    }
    
    func didEndDisplaying(tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath) {
        // Default implementation does nothing
    }
    
    func willDisplayHeaderView(_ tableView: UITableView, view: UIView, section: Int) {
        // Default implementation does nothing
    }
    
    func heightForRowAt(tableView: UITableView, indexPath: IndexPath) -> CGFloat{
        return CGFloat(0.0)
    }
    
    func heightForHeaderInSection(_ tableView: UITableView, section: Int) -> CGFloat{
        return CGFloat(0.0)
    }
    
    func heightForFooterInSection(_ tableView: UITableView, section: Int) -> CGFloat{
        return CGFloat(0.0)
    }
    
    func commit(tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Default implementation does nothing
    }
    
    func trailingSwipeActions(tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
}
