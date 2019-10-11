//
//  PerformantTitlesTableViewController.swift
//  SelfSizingCollectionViewCells
//
//  Created by Tom Kraina on 10/10/2019.
//  Copyright © 2019 Tom Kraina. All rights reserved.
//

import UIKit

final class PerformantTableViewController: UITableViewController {

    private lazy var dataSource = self.makeDataSource()
    private lazy var heightCalculator = TitlesTableViewCellHeightCalculator(tableView: self.tableView)

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.tableView.register(cellOfType: TitlesTableViewCell.self)

        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(reloadItems)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(shuffleItems)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItems))
        ]
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // If it was rotated, for example, we need to invalidate the tableView's layout
        if self.view.frame.size != size {
            coordinator.animate(alongsideTransition: { _ in self.tableView.invalidateLayout() }, completion: nil)
        }
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        // We need to handle any change that will affect layout and/or anything that affects size of a UILabel
        if newCollection.hasDifferentTextAppearance(comparedTo: self.traitCollection) {
            print(type(of: self), #function, "Invalidating tableView layout...")
            coordinator.animate(alongsideTransition: { _ in self.tableView.invalidateLayout() }, completion: nil)
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("----- CALCULATION", indexPath.row)
        let cellData = self.dataSource
        let value = self.heightCalculator.calculateHeight(for: cellData, traitCollection: self.traitCollection)
        print("----- /CALCULATION", indexPath.row)
        return value
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // When profiling scrolling performance, change to a higher number (e.g. 100)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitlesTableViewCell = tableView.dequeueCell(at: indexPath)

        cell.setDataSource(self.dataSource)

        // Preparing the cell's frame with correct width helps if the app is started in landscape.
        // Note: We assumes that the cell is going to have the same width as it's table view.
        cell.frame.size.width = tableView.bounds.width

        // The trick here is to force the cell to layout its collectionView so it has the right height before returning it.
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        return cell
    }
}

// MARK: - Privates

private extension PerformantTableViewController {

    var allTitles: [String] {
        return [
            "Short",
            "Medium title",
            "A little bit longer title",
            "Very very very very very long title that is expected to be clipped in the end in landscape."
        ]
    }

    func makeDataSource(titles: [String]? = nil) -> UICollectionViewDataSource {
        return TitlesCollectionViewDataSource(titles: titles ?? self.allTitles)
    }

    @IBAction private func reloadItems() {
        self.dataSource = self.makeDataSource()
        self.tableView.reloadData()
    }

    @IBAction private func shuffleItems() {
        let existingTitles = (self.dataSource as! TitlesCollectionViewDataSource).titles

        self.dataSource = self.makeDataSource(titles: existingTitles.shuffled())
        self.tableView.reloadData()
    }

    @IBAction private func addItems() {
        guard let randomTitle = self.allTitles.randomElement() else { return }

        let existingTitles = (self.dataSource as! TitlesCollectionViewDataSource).titles
        self.dataSource = self.makeDataSource(titles: existingTitles + [randomTitle])
        self.tableView.reloadData()
    }
}

extension UITableView {

    /// Makes the table view invalidate its layout (and re-calculate the height of the cells)
    func invalidateLayout() {
        self.beginUpdates()
        self.endUpdates()
    }
}

extension UITraitCollection {

    func hasDifferentTextAppearance(comparedTo traitCollection: UITraitCollection?) -> Bool {
        var result = self.preferredContentSizeCategory != traitCollection?.preferredContentSizeCategory

        if #available(iOS 13.0, *) {
            result = result || self.legibilityWeight != traitCollection?.legibilityWeight
        }

        return result
    }
}
