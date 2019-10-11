//
//  TableViewController.swift
//  SelfSizingCollectionViewCells
//
//  Created by Tom Kraina on 09/10/2019.
//  Copyright © 2019 Tom Kraina. All rights reserved.
//

import UIKit

final class TableViewController: UITableViewController {

    private lazy var dataSource = self.makeDataSource()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tableView.register(cellOfType: TitlesTableViewCell.self)

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
            coordinator.animate(alongsideTransition: { (context) in
                // Makes the table view invalidate its layout (and re-calculate the height of the cells)
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }, completion: nil)
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // When profiling scrolling performance, change to a higher number (e.g. 100)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitlesTableViewCell", for: indexPath) as! TitlesTableViewCell

        // Preparing the cell's frame with correct width helps if the app is started into landscape.
        cell.frame.size.width = tableView.safeAreaLayoutGuide.layoutFrame.width
        cell.frame.size.height = 100

        cell.setDataSource(self.dataSource)

        // The trick here is to force the cell to layout its collectionView so it has the right height before returning it.
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        return cell
    }
}

// MARK: - Privates

private extension TableViewController {

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
