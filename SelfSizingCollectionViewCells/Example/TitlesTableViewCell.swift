//
//  TitlesTableViewCell.swift
//  SelfSizingCollectionViewCells
//
//  Created by Tom Kraina on 10/10/2019.
//  Copyright © 2019 Tom Kraina. All rights reserved.
//

import UIKit

extension UICollectionViewDataSource {

    func allIndexPaths(in collectionView: UICollectionView) -> [IndexPath] {
        var indexPaths: [IndexPath] = []

        let numberOfSections = self.numberOfSections?(in: collectionView) ?? 1
        for section in (0..<numberOfSections)  {
            let numberOfItems = self.collectionView(collectionView, numberOfItemsInSection: section)
            for item in (0..<numberOfItems) {
                indexPaths.append(IndexPath(item: item, section: section))
            }
        }

        return indexPaths
    }
}

final class TitlesTableViewCell: UITableViewCell {

    private lazy var collectionView: UICollectionView = self.makeCollectionView()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setDataSource(_ dataSource: UICollectionViewDataSource, forceReloadData: Bool = false) {
        print(type(of: self), #function)
        self.collectionView.dataSource = dataSource

        if forceReloadData {
            if collectionView.dataSource?.isEqual(dataSource) == true {
                print("Reload all items")
                // If the collectionView is offscreen (e.g. for height calculation purposes), it does not get any `traitCollectionDidChange` updates
                // so it can't update the font used in the cell, therefore we need to reload the cells.
                // NOTE: Reload items calls `traitCollectionDidChange` internally?
                self.collectionView.reloadItems(at: dataSource.allIndexPaths(in: self.collectionView))
            } else {
                print("Reloading data ...")
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: - UIView

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print(type(of: self), #function, previousTraitCollection?.description ?? "", "->", self.traitCollection)
        super.traitCollectionDidChange(previousTraitCollection)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        print(type(of: self), #function, horizontalFittingPriority, verticalFittingPriority, targetSize, "->", size)
        return size
    }

    // MARK: - Private

    private func setup() {
        self.contentView.addSubviewAndPinToSides(self.collectionView)
    }

    private func makeCollectionView() -> UICollectionView {
        let collectionView = SelfSizingCollectionView(frame: self.bounds, collectionViewLayout: MaxWidthCollectionViewFlowLayout())
        collectionView.register(cellOfType: TitleLabelCollectionViewCell.self)
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }

        return collectionView
    }
}

// MARK: - ReuseIdentifiable

extension TitlesTableViewCell: ReuseIdentifiable {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
