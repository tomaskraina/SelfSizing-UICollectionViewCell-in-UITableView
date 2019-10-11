//
//  ViewController.swift
//  SelfSizingCollectionViewCells
//
//  Created by Tom Kraina on 03/05/2019.
//  Copyright © 2019 Tom Kraina. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak private var collectionView: UICollectionView!

    private lazy var dataSource = self.makeDataSource()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.collectionView.register(cellOfType: TitleLabelCollectionViewCell.self)
        self.collectionView.dataSource = self.dataSource

        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(reloadItems)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(shuffleItems)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItems))
        ]
    }
}

// MARK: - Privates

private extension ViewController {

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
        self.collectionView.dataSource = self.dataSource
    }

    @IBAction private func shuffleItems() {
        let existingTitles = (self.dataSource as! TitlesCollectionViewDataSource).titles

        self.dataSource = self.makeDataSource(titles: existingTitles.shuffled())
        self.collectionView.dataSource = self.dataSource
    }

    @IBAction private func addItems() {
        guard let randomTitle = self.allTitles.randomElement() else { return }

        let existingTitles = (self.dataSource as! TitlesCollectionViewDataSource).titles
        self.dataSource = self.makeDataSource(titles: existingTitles + [randomTitle])
        self.collectionView.dataSource = self.dataSource
    }
}

