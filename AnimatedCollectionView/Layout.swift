//
//  Layout.swift
//  AnimatedCollectionView
//
//  Created by Patrick Lynch on 6/17/16.
//  Copyright © 2016 Patrick Lynch. All rights reserved.
//

import UIKit

private extension Dictionary {
    func map<K : Hashable, V>(@noescape transform: (Key, Value) -> (K, V)) -> [K:V] {
        var result: [K:V] = [:]
        for x in self {
            let (key, val) = transform(x)
            result[key] = val
        }
        return result
    }
}

class Layout: UICollectionViewFlowLayout {
    
    private var insertedIndexPaths = [NSIndexPath]()
    private var deletedIndexPaths = [NSIndexPath]()
    private var deletedSections = [Int]()
    private var insertedSections = [Int]()
    
    private var currentCellAttributes: [NSIndexPath: UICollectionViewLayoutAttributes] = [:]
    private var cachedCellAttributes: [NSIndexPath: UICollectionViewLayoutAttributes] = [:]
    
    func insertIndexPaths(indexPaths: [NSIndexPath]) {
        guard let collectionView = self.collectionView where !indexPaths.isEmpty else { return }
        collectionView.insertItemsAtIndexPaths(indexPaths)
    }
    
    func deleteIndexPaths(indexPaths: [NSIndexPath]) {
        guard let collectionView = self.collectionView where !indexPaths.isEmpty else { return }
        collectionView.deleteItemsAtIndexPaths(indexPaths)
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
            where insertedIndexPaths.contains(itemIndexPath) {
            return attributesForDeletion(attributes)
        }
        return nil
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
            where deletedIndexPaths.contains(itemIndexPath) {
            return attributesForDeletion(attributes)
        }
        return nil
    }
    func attributesForInsertion(fromAttribtues: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return fromAttribtues
    }
    
    func attributesForDeletion(fromAttribtues: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return fromAttribtues
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        cachedCellAttributes = currentCellAttributes.map {
            ($0.0.copy() as!NSIndexPath , $0.1.copy() as! UICollectionViewLayoutAttributes)
        }
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItemAtIndexPath(indexPath)
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        for item in updateItems {
            switch item.updateAction {
            case UICollectionUpdateAction.Insert:
                if let indexPath = item.indexPathAfterUpdate {
                    if indexPath.item != NSNotFound {
                        insertedIndexPaths.append(indexPath)
                    } else  {
                        insertedSections.append(indexPath.section)
                    }
                }
                
            case UICollectionUpdateAction.Delete:
                if let indexPath = item.indexPathBeforeUpdate {
                    if indexPath.item != NSNotFound {
                        deletedIndexPaths.append(indexPath)
                    } else  {
                        deletedSections.append(indexPath.section)
                    }
                }
                
            default:()
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertedIndexPaths = []
        deletedIndexPaths = []
        deletedSections = []
        insertedSections = []
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElementsInRect(rect)
        
        for attribute in attributes ?? [] {
            switch attribute.representedElementCategory {
            case .Cell:
                currentCellAttributes[attribute.indexPath] = attribute
            default:()
            }
        }
        
        return attributes
    }
}
