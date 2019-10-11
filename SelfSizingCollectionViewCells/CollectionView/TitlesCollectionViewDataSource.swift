//
//  TitlesCollectionViewDataSource.swift
//  SelfSizingCollectionViewCells
//
//  Created by Tom Kraina on 09/10/2019.
//  Copyright © 2019 Tom Kraina. All rights reserved.
//

import UIKit

final class TitlesCollectionViewDataSource: NSObject {

    let titles: [String]

    init(titles: [String]) {
        self.titles = titles
    }
}

// MARK: - UICollectionViewDataSource

extension TitlesCollectionViewDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TitleLabelCollectionViewCell = collectionView.dequeueCell(at: indexPath)

        // configure
        cell.titleLabel.text = self.titles[indexPath.item]

        return cell
    }
}
