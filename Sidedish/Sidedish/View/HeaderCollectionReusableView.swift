//
//  HeaderCollectionReusableView.swift
//  Sidedish
//
//  Created by Issac on 2021/04/22.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    func configure(title: String, count: Int) {
        self.title.text = title
        self.countLabel.text = "\(count)"
    }
}
