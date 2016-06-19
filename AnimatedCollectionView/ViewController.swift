//
//  ViewController.swift
//  AnimatedCollectionView
//
//  Created by Patrick Lynch on 6/17/16.
//  Copyright © 2016 Patrick Lynch. All rights reserved.
//

import UIKit

let allModels = [
    Model(text: "One", color: UIColor.redColor()),
    Model(text: "Two", color: UIColor.greenColor()),
    Model(text: "Three", color: UIColor.blueColor()),
    Model(text: "Four", color: UIColor.orangeColor()),
    Model(text: "Five", color: UIColor.purpleColor()),
    Model(text: "Six", color: UIColor.redColor()),
    Model(text: "Seven", color: UIColor.greenColor()),
    Model(text: "Eight", color: UIColor.blueColor()),
    Model(text: "Nine", color: UIColor.orangeColor()),
    Model(text: "Ten", color: UIColor.purpleColor())
]

struct Model: Hashable, Equatable {
    let text: String
    let color: UIColor
    
    // MARK: - Hashable
    
    var hashValue: Int {
        return text.hashValue + color.hashValue
    }
}
func ==(lhs: Model, rhs: Model) -> Bool { return lhs.hashValue == rhs.hashValue }

class MyLayout: Layout {
    
    override func insertIndexPaths(indexPaths: [NSIndexPath]) {
        guard let collectionView = self.collectionView where !indexPaths.isEmpty else { return }
        UIView.animateWithDuration(
            0.75,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1.0,
            options: [],
            animations: {
                collectionView.insertItemsAtIndexPaths(indexPaths)
            },
            completion: nil
        )
    }
    
    override func deleteIndexPaths(indexPaths: [NSIndexPath]) {
        guard let collectionView = self.collectionView where !indexPaths.isEmpty else { return }
        UIView.animateWithDuration(
            0.15,
            delay: 0.0,
            options: [],
            animations: {
                collectionView.deleteItemsAtIndexPaths(indexPaths)
            },
            completion: nil
        )
    }
    
    override func attributesForInsertion(fromAttribtues: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = fromAttribtues
        attributes.transform = CGAffineTransformMakeTranslation(0.0, 80.0)
        attributes.alpha = 0.0
        return attributes
    }
    
    override func attributesForDeletion(fromAttribtues: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = fromAttribtues
        attributes.transform = CGAffineTransformMakeTranslation(0.0, 30.0)
        attributes.alpha = 0.0
        return attributes
    }
}

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, DataSourceChangeDelegate {
    
    let dataSource = DataSource()
    
    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.randomize()
    }
    
    func randomize() {
        dispatch_after(2.0) {
            self.dataSource.models = []
            dispatch_after(0.5) {
                self.dataSource.models = allModels.filter { _ in arc4random() % 10 > 5 }
                self.randomize()
            }
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    // MARK: - DataSourceChangeDelegate
    
    func dataSource(dataSource: DataSource, didChange change: DataSourceChange) {
        guard let layout = collectionView.collectionViewLayout as? Layout else {
            collectionView.reloadData()
            return
        }
        
        if !change.deletedIndexPaths.isEmpty && !change.insertedIndexPaths.isEmpty {
            
        } else if !change.insertedIndexPaths.isEmpty {
            layout.insertIndexPaths(change.insertedIndexPaths)
            
        } else if !change.deletedIndexPaths.isEmpty {
            layout.deleteIndexPaths(change.deletedIndexPaths)
        }
    }
}
