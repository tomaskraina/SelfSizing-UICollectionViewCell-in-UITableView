//
//  TitlesCollectionViewFlowLayout.swift
//  SelfSizingCollectionViewCells
//
//  Created by Tom Kraina on 09/10/2019.
//  Copyright © 2019 Tom Kraina. All rights reserved.
//

import UIKit

// If the size of the collection view cell is not explicitelly restricted, we get the following error:
//2019-10-09 11:07:13.459621+0200 SelfSizingCollectionViewCells[9375:129225] The behavior of the UICollectionViewFlowLayout is not defined because:
//2019-10-09 11:07:13.459782+0200 SelfSizingCollectionViewCells[9375:129225] the item width must be less than the width of the UICollectionView minus the section insets left and right values, minus the content insets left and right values.
//2019-10-09 11:07:13.459895+0200 SelfSizingCollectionViewCells[9375:129225] Please check the values returned by the delegate.
//2019-10-09 11:07:13.460574+0200 SelfSizingCollectionViewCells[9375:129225] The relevant UICollectionViewFlowLayout instance is <UICollectionViewFlowLayout: 0x7fdc0e2040f0>, and it is attached to <UICollectionView: 0x7fdc0f81b600; frame = (0 0; 375 667); clipsToBounds = YES; autoresize = RM+BM; gestureRecognizers = <NSArray: 0x600003f1b330>; layer = <CALayer: 0x600003155280>; contentOffset: {0, -20}; contentSize: {375, 50}; adjustedContentInset: {20, 0, 0, 0}; layout: <UICollectionViewFlowLayout: 0x7fdc0e2040f0>; dataSource: <SelfSizingCollectionViewCells.TitlesCollectionViewDataSource: 0x60000330c260>>.
//2019-10-09 11:07:13.460693+0200 SelfSizingCollectionViewCells[9375:129225] Make a symbolic breakpoint at UICollectionViewFlowLayoutBreakForInvalidSizes to catch this in the debugger.
//2019-10-09 11:07:13.460803+0200 SelfSizingCollectionViewCells[9375:129225] The behavior of the UICollectionViewFlowLayout is not defined because:
//2019-10-09 11:07:13.460897+0200 SelfSizingCollectionViewCells[9375:129225] the item width must be less than the width of the UICollectionView minus the section insets left and right values, minus the content insets left and right values.
//2019-10-09 11:07:13.534388+0200 SelfSizingCollectionViewCells[9375:129225] Please check the values returned by the delegate.
//2019-10-09 11:07:13.534664+0200 SelfSizingCollectionViewCells[9375:129225] The relevant UICollectionViewFlowLayout instance is <UICollectionViewFlowLayout: 0x7fdc0e2040f0>, and it is attached to <UICollectionView: 0x7fdc0f81b600; frame = (0 0; 375 667); clipsToBounds = YES; autoresize = RM+BM; gestureRecognizers = <NSArray: 0x600003f1b330>; layer = <CALayer: 0x600003155280>; contentOffset: {0, -20}; contentSize: {375, 50}; adjustedContentInset: {20, 0, 0, 0}; layout: <UICollectionViewFlowLayout: 0x7fdc0e2040f0>; dataSource: <SelfSizingCollectionViewCells.TitlesCollectionViewDataSource: 0x60000330c260>>.
//2019-10-09 11:07:13.534779+0200 SelfSizingCollectionViewCells[9375:129225] Make a symbolic breakpoint at UICollectionViewFlowLayoutBreakForInvalidSizes to catch this in the debugger.

/// Custom `UICollectionViewFlowLayout` subclass that uses `MaxWidthCollectionViewLayoutAttributes` in order to pass `maxItemWidth` to a `TitleLabelCollectionViewCell` instance
final class MaxWidthCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        self.setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    // MARK: - UICollectionViewLayout

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }

        print(#function, rect)
        superAttributes.forEach { print($0) }
        let maxWidth = self.collectionView.map { self.maxItemWidth(in: $0) }
        return superAttributes.map { MaxWidthCollectionViewLayoutAttributes(forCellWith: $0, maxItemWidth: maxWidth) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let superAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }

        let maxWidth = self.collectionView.map { self.maxItemWidth(in: $0) }
        return MaxWidthCollectionViewLayoutAttributes(forCellWith: superAttributes, maxItemWidth: maxWidth)
    }

    // MARK: - Private

    private func setup() {
        self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10
        self.sectionInset = .init(top: 8, left: 8, bottom: 8, right: 8)
    }

    private func maxItemWidth(in collectionView: UICollectionView) -> CGFloat {
        return collectionView.bounds.width - self.sectionInset.left - self.sectionInset.right - collectionView.adjustedContentInset.left - collectionView.adjustedContentInset.right
    }
}

