//
//  TransactionListCollViewDataSource.swift
//  PDFReport
//
//  Created by Techahead on 01/08/25.
//  

import Foundation
import UIKit

// ***********************************************************//
// MARK: - COLLECTIONVIEW OUTPUT PROTOCOLS
// ***********************************************************//

protocol TransactionListCollViewDataSourceOutputs: AnyObject {
}

// ***********************************************************//
// MARK: - CollectionView PROTOCOL METHODS
// ***********************************************************//

final class TransactionListCollViewDataSource: CollectionViewItemDataSource {
    
    private weak var entities: TransactionListEntities!
    private weak var presenter: TransactionListCollViewDataSourceOutputs?

    init(entities: TransactionListEntities, presenter: TransactionListCollViewDataSourceOutputs) {
        self.entities = entities
        self.presenter = presenter
    }
    
    func numberOfItems(collView: UICollectionView, section: Int) -> Int{
        return 2
    }

    func itemCell(collView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func didSelect(collView: UICollectionView, indexPath: IndexPath) {
        
    }
}

