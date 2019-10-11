//
//  UIView+autolayout.swift
//  SelfSizingCollectionViewCells
//
//  Created by Tom Kraina on 11/10/2019.
//  Copyright © 2019 Tom Kraina. All rights reserved.
//

import UIKit

extension UIView {

    func addSubviewAndPinToSides(_ view: UIView, constraintToMargins toMargins: Bool = false) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        NSLayoutConstraint.activate([
            (toMargins ? self.layoutMarginsGuide.leftAnchor : self.leftAnchor).constraint(equalTo: view.leftAnchor),
            (toMargins ? self.layoutMarginsGuide.rightAnchor : self.rightAnchor ).constraint(equalTo: view.rightAnchor),
            (toMargins ? self.layoutMarginsGuide.topAnchor : self.topAnchor).constraint(equalTo: view.topAnchor),
            (toMargins ? self.layoutMarginsGuide.bottomAnchor : self.bottomAnchor).constraint(equalTo: view.bottomAnchor)
        ])
    }
}
