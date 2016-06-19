//
//  DataSource.swift
//  AnimatedCollectionView
//
//  Created by Patrick Lynch on 6/17/16.
//  Copyright © 2016 Patrick Lynch. All rights reserved.
//

import UIKit

class ModelCell: UICollectionViewCell {
    
    @IBOutlet private weak var textView: UITextView!
    
    var model: Model? {
        didSet {
            textView.text = model?.text
            backgroundColor = model?.color
        }
    }
}

struct DataSourceChange {
    let insertedIndexPaths: [NSIndexPath]
    let deletedIndexPaths: [NSIndexPath]
}

protocol DataSourceChangeDelegate: class {
    func dataSource(dataSource: DataSource, didChange change: DataSourceChange)
}

class DataSource: NSObject, UICollectionViewDataSource {
    
    weak var delegate: DataSourceChangeDelegate?
    
    var models: [Model] = [] {
        didSet {
            let inserted = models.filter { !oldValue.contains($0) }.map { NSIndexPath(forItem: Int(models.indexOf($0)!), inSection: 0) }
            let deleted = oldValue.filter { !models.contains($0) }.map { NSIndexPath(forItem: Int(oldValue.indexOf($0)!), inSection: 0) }
            let change = DataSourceChange(insertedIndexPaths: inserted, deletedIndexPaths: deleted)
            delegate?.dataSource(self, didChange: change)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ModelCell", forIndexPath: indexPath) as! ModelCell
        cell.model = model
        return cell
    }
}
