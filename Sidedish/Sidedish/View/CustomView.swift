//
//  CustomView.swift
//  Sidedish
//
//  Created by Ador on 2021/04/27.
//

import UIKit

class CustomView: UIView {
    @IBOutlet weak var eventLabel: BadgeLabel!
    @IBOutlet weak var launchLabel: BadgeLabel!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var deliveryInfo: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var sellingPrice: UILabel!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    func configure(productName: String = "", item: DetailItem) {
        title.text = productName
        productDescription.text = item.productDescription
        point.text = item.point
        deliveryInfo.text = item.deliveryInfo
        deliveryFee.text = item.deleveryFee
        sellingPrice.text = item.prices.first
        originalPrice.attributedText = item.prices.last?.attributedStringOfStrikethroughStyle()
        
    }
    
    @IBAction func upQuantity(_ sender: UIButton) {
        
    }
    
    @IBAction func downQuantity(_ sender: UIButton) {
        
    }
    
    
    @IBAction func sendOrder(_ sender: Any) {
        
    }
}
