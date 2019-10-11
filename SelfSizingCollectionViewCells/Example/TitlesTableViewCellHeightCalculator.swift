//
//  TitlesTableViewCellHeightCalculator.swift
//  SelfSizingCollectionViewCells
//
//  Created by Tom Kraina on 11/10/2019.
//  Copyright © 2019 Tom Kraina. All rights reserved.
//

import UIKit

final class TitlesTableViewCellHeightCalculator {

    let tableView: UITableView

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    lazy var cell: TitlesTableViewCell = self.makeCell()
    lazy var wrapperViewController: UIViewController = self.makeWrapperViewController()

    private func makeCell() -> TitlesTableViewCell {
        let cell = TitlesTableViewCell(style: .default, reuseIdentifier: TitlesTableViewCell.reuseIdentifier)

        // FIXME: cell contained in wrapper vs iPhone X (with notch) in landscape
        cell.isHidden = true
        cell.autoresizingMask = [.flexibleWidth]
//        tableView.addSubview(cell)
//        cell.translatesAutoresizingMaskIntoConstraints = false
        self.wrapperViewController.children.first!.view.addSubview(cell)

        return cell
    }

    private func makeCollectionView() -> UICollectionView {
        let collectionView = SelfSizingCollectionView(frame: .null, collectionViewLayout: MaxWidthCollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cellOfType: TitleLabelCollectionViewCell.self)
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }

        return collectionView
    }

    private func makeWrapperViewController() -> UIViewController {

        let wrapperViewController = UIViewController()
        let childViewController = UIViewController()
        wrapperViewController.addChild(childViewController)
        wrapperViewController.view.addSubviewAndPinToSides(childViewController.view)
        childViewController.didMove(toParent: wrapperViewController)

        return wrapperViewController
    }

    func calculateHeight(for cellData: UICollectionViewDataSource, traitCollection: UITraitCollection) -> CGFloat {
        return self.calculateHeightOnCell(for: cellData, traitCollection: traitCollection)
    }

    private func calculateHeightOnCell(for cellData: UICollectionViewDataSource, traitCollection: UITraitCollection) -> CGFloat {

        // FIXME: calculate correct width for iPhones with notch?
        let width = self.tableView.safeAreaLayoutGuide.layoutFrame.width
        let availableSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)

        var size: CGSize = .zero
        UIView.performWithoutAnimation {
            self.updateTraitCollection(traitCollection)
            cell.setDataSource(cellData, forceReloadData: true)

            cell.frame.size.width = width

            // The following line is super important - we need to make sure the frame is large enough to contain
            // all cells in the contained collection view.
            // If not, the default implementation of UIFlowLayout will optimize and won't calculate correct frame
            // for the cells that would not be visible (are not within the containing bounds), resulting in a wrong heigh calculation
            cell.frame.size.height = self.tableView.bounds.height
            cell.setNeedsLayout()
            print(type(of: self), "LayoutIfNeeded() ...")
            cell.layoutIfNeeded()


            print(type(of: self), "Calculating size ...")
            assert(self.cell.traitCollection == traitCollection, "Trait collection on the offscreen cell are out of date")
            // If the `TitlesTableViewCell` didn't use autolayout, we would use `sizeThatFits()` instead.
            size = self.cell.systemLayoutSizeFitting(availableSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .defaultLow)
        }

        print("Calculated size:", size.integral, "for:", cell, ", availableSize:", availableSize)
        return ceil(size.height)

    }

    private func updateTraitCollection(_ traitCollection: UITraitCollection) {
        guard let childViewController = self.wrapperViewController.children.first else { fatalError() }

        print(type(of: self), #function, traitCollection)
        self.wrapperViewController.setOverrideTraitCollection(traitCollection, forChild: childViewController)
    }
}

extension CGSize {

    var integral: CGSize {
        return CGSize(width: ceil(self.width), height: ceil(self.height))
    }
}
