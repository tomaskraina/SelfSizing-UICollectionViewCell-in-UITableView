//
//  TitleLabelCollectionViewCell.swift
//  SelfSizingCollectionViewCells
//
//  Created by Tom Kraina on 09/10/2019.
//  Copyright © 2019 Tom Kraina. All rights reserved.
//

import UIKit

/// Custom self-sizing `UICollectionViewCell` that contains one one-line `UILabel`, has `maxWidth` constaint, and can apply `TitleLabelCollectionViewLayoutAttributes`
final class TitleLabelCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets

    private(set) lazy var titleLabel: UILabel! = self.makeLabel()
    private(set) lazy var maxWidthConstraint: NSLayoutConstraint = self.makeMaxWidthConstraint()

    // MARK: - Properties

    var titleLabelFontStyle: UIFont.TextStyle = .body

    var maxWidth: CGFloat? {
        didSet {
            if let width = self.maxWidth {
                self.maxWidthConstraint.constant = width
                self.maxWidthConstraint.isActive = true
            } else {
                self.maxWidthConstraint.isActive = false
            }
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

//    override func didMoveToSuperview() {
//        print(type(of: self), #function)
//        super.didMoveToSuperview()
//    }

//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        print(type(of: self), #function)
//        super.traitCollectionDidChange(previousTraitCollection)
//
//        if self.traitCollection.hasDifferentTextAppearance(comparedTo: previousTraitCollection) {
//            self.updateFontIfNeeded()
//        }
//    }

    // MARK: - UIView

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        print(type(of: self), #function, horizontalFittingPriority, verticalFittingPriority, targetSize, "->", size)
        return size
    }

    // MARK: - UICollectionReusableView

    override func prepareForReuse() {
        print(type(of: self), #function)
        super.prepareForReuse()

        // super important for offscreen size calculation.
        self.updateFontIfNeeded()
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let customAttributes = layoutAttributes as? MaxWidthCollectionViewLayoutAttributes else {
            fatalError("Provided attributes are not of expected type 'MaxWidthCollectionViewLayoutAttributes': \(layoutAttributes)")
        }

        self.maxWidth = customAttributes.maxItemWidth
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes) // Calls `systemLayoutSizeFitting()` internally
        print(type(of: self), #function)
        print(layoutAttributes, "\n->\n", attributes)
        return attributes
    }

    // MARK: - Private

    private func setup() {
        self.contentView.addSubviewAndPinToSides(self.titleLabel, constraintToMargins: true)
        self.updateFontIfNeeded()
        self.backgroundColor = .systemTeal
    }

    private func makeMaxWidthConstraint() -> NSLayoutConstraint {
        let constraint = self.contentView.widthAnchor.constraint(lessThanOrEqualToConstant: 0)
        // Don't make it .required in order to avoid UIViewAlertForUnsatisfiableConstraints when rotating the device.
        constraint.priority = .init(999)
        return constraint
    }

    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = false
        if #available(iOS 13.0, *) {
            label.textColor = .label
        } else {
            label.textColor = .black
        }

        return label
    }

    private func updateFontIfNeeded() {
        let newFont = UIFont.preferredFont(forTextStyle: self.titleLabelFontStyle, compatibleWith: self.traitCollection)
        if newFont != self.titleLabel.font {
            print(type(of: self), #function, self.titleLabel.font?.description ?? "nil", "->", newFont)
            self.titleLabel.font = newFont
        }
    }
}

// MARK: - ReuseIdentifiable

extension TitleLabelCollectionViewCell: ReuseIdentifiable {

    static var reuseIdentifier: String {
         return String(describing: self)
    }
}
