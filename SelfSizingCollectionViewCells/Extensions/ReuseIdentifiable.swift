//
//  UICollectionView+dequeueCellT.swift
//  SelfSizingCollectionViewCells
//
//  Created by Tom Kraina on 09/10/2019.
//  Copyright © 2019 Tom Kraina. All rights reserved.
//

import UIKit

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension UICollectionView {

    func register<T: UICollectionViewCell & ReuseIdentifiable>(cellOfType: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueCell<T: UICollectionViewCell & ReuseIdentifiable>(at indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Dequeued cell with reuseIdentifier=\(T.reuseIdentifier) is expected to be of type=\(T.self)")
        }

        return cell
    }
}

extension UITableView {

    func register<T: UITableViewCell & ReuseIdentifiable>(cellOfType: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueCell<T: UITableViewCell & ReuseIdentifiable>(at indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Dequeued cell with reuseIdentifier=\(T.reuseIdentifier) is expected to be of type=\(T.self)")
        }

        return cell
    }
}

