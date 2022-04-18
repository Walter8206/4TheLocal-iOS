//
//  OrderDetailCell.swift
//  4TheLocal
//
//  Created by Mahamudul on 21/8/21.
//

import UIKit

class OrderDetailCell: UITableViewCell {
    
    
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var desc_lbl: UILabel!
    
    @IBOutlet weak var status_lbl: UILabel!
    
    static let identifire = "OrderDetailCell"
    static func nib() -> UINib{
        return UINib(nibName: identifire, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension OrderDetailCell{
    
    func setHeader(title: String, order: Order){
        title_lbl.text = title
        title_lbl.font.withSize(25)
        title_lbl.textColor = UIColor.black
        status_lbl.text = ""
    }
    
    func setOrderDate(order: Order){
        title_lbl.text = "Order Date:"
        status_lbl.text = order.createdAt
    }
    
    func setProductTitle(order: Order){
        var name = "\n\n"
        var price = "\n\n"
        
        if let items = order.lineItems{
            for item in items{
                let quantity = String(item.quantity ?? 0) + " X "
                name += quantity + (item.name ?? "") + " \n\n"
                price += "$" + (item.price ?? "0") + "\n\n"
            }
        }
        title_lbl.text = name
        status_lbl.text = price
        title_lbl.textColor = UIColor.red
    }
    
    func setSubtotal(order: Order){
        title_lbl.text = "Subtotal:"
        status_lbl.text = "$" + (order.subtotal ?? "")
    }
    
    func setDiscount(order: Order){
        title_lbl.text = "Discount:"
        status_lbl.text = "$" + (order.totalDiscount ?? "")
    }
    
    func setTotal(order: Order){
        title_lbl.text = "Total:"
        status_lbl.text = "$" + (order.total ?? "")
    }
    
    func setBillingName(order: Order){
        title_lbl.text = (order.billingAddress?.firstName ?? "") + " " + (order.billingAddress?.lastName ?? "")
        desc_lbl.text = order.billingAddress?.address1
    }
    
    func setBillingPhone(order: Order){
        title_lbl.text = "Mobile Number"
        desc_lbl.text = order.billingAddress?.phone
    }
    
    func setBillingEmail(order: Order){
        title_lbl.text = "Email"
        desc_lbl.text = order.billingAddress?.email
    }
}
