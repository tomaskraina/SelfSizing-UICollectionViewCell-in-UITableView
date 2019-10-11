//
//  SelfSizingCollectionView.swift
//  SelfSizingCollectionViewCells
//
//  Created by Tom Kraina on 09/10/2019.
//  Copyright © 2019 Tom Kraina. All rights reserved.
//

import UIKit

final class SelfSizingCollectionView: UICollectionView {

    private var contentSizeObservation: NSKeyValueObservation?

    // MARK: - Lifecycle

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setupContentSizeObservation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupContentSizeObservation()
    }

    // MARK: - UIView

    override var intrinsicContentSize: CGSize {
        let contentSize = self.contentSize
        print(#function, contentSize)
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print(type(of: self), #function)
        super.traitCollectionDidChange(previousTraitCollection)

        // We need to handle any change that will affect layout and/or anything that affects size of a UILabel
        if self.traitCollection.hasDifferentTextAppearance(comparedTo: previousTraitCollection) {
            self.collectionViewLayout.invalidateLayout()
        }
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        print(type(of: self), #function, targetSize, "->", size)
        return size
    }

    // MARK: - Private

    private func setupContentSizeObservation() {
        // Observing the value of contentSize seems to be the only reliable way to get the contentSize after the collection view lays out its subviews.
        self.contentSizeObservation = self.observe(\.contentSize, options: [.old, .new]) { [weak self] _, change in
            // If we don't specify `options: [.old, .new]`, the change.oldValue and .newValue will always be `nil`.
            if change.newValue != change.oldValue {
                self?.invalidateIntrinsicContentSize()
            }
        }
    }
}
