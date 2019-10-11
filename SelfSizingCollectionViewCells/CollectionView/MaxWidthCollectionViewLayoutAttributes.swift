//
//  MaxWidthCollectionViewLayoutAttributes.swift
//  SelfSizingCollectionViewCells
//
//  Created by Tom Kraina on 09/10/2019.
//  Copyright © 2019 Tom Kraina. All rights reserved.
//

import UIKit

/// Custom `UICollectionViewLayoutAttributes` subclass that allows us to pass an extra attribute `maxItemWidth`
final class MaxWidthCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    var maxItemWidth: CGFloat?

    // MARK: - Lifecycle

    convenience init(forCellWith attributes: UICollectionViewLayoutAttributes, maxItemWidth: CGFloat? = nil) {

        switch attributes.representedElementCategory {
        case .cell:
            self.init(forCellWith: attributes.indexPath)
        case .decorationView:
            self.init(forDecorationViewOfKind: attributes.representedElementKind!, with: attributes.indexPath)
        case .supplementaryView:
            self.init(forSupplementaryViewOfKind: attributes.representedElementKind!, with: attributes.indexPath)
        @unknown default:
            assertionFailure("Unknown UICollectionView.ElementCategory \(attributes.representedElementCategory.rawValue)")
            self.init(forCellWith: attributes.indexPath)
        }

        self.frame = attributes.frame
        self.isHidden = attributes.isHidden
        self.zIndex = attributes.zIndex
        self.alpha = attributes.alpha
        if let attributes = attributes as? MaxWidthCollectionViewLayoutAttributes {
            self.maxItemWidth = attributes.maxItemWidth
        }

        self.maxItemWidth = maxItemWidth
    }

    // MARK: - NSObject

    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? MaxWidthCollectionViewLayoutAttributes else { return false }
        guard self.maxItemWidth == rhs.maxItemWidth else { return false }

        return super.isEqual(object)
    }

    override var description: String {
        return super.description + "maxItemWidth = \(self.maxItemWidth?.description ?? "nil"); "
    }

    // MARK: - NSCopying

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone)
        if let attributesCopy = copy as? MaxWidthCollectionViewLayoutAttributes {
            attributesCopy.maxItemWidth = self.maxItemWidth
        }

        return copy
    }
}
