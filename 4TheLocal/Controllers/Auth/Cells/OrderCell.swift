//
//  OrderCell.swift
//  4TheLocal
//
//  Created by Mahamudul on 16/8/21.
//

import UIKit
import Combine

class OrderCell: UITableViewCell {
    
    
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var price_lbl: UILabel!
    @IBOutlet weak var delete_btn: UIButton!
    @IBOutlet weak var delete_view: DesignableView!
    @IBOutlet weak var separatorView: UIView!
    
    var mItem: OrderItem!
    static let identifire = "OrderCell"
    let deletePressed = PassthroughSubject<OrderItem?, Never>()
    
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
    
    
    func config(item: OrderItem){
        separatorView.isHidden = true
        mItem = item
        
        
        if item.orderType == 2{
            title_lbl.text = "Coupon: " + (item.title ?? "")
            price_lbl.text = "-$" + String(item.price ?? 0)
        }
        else{
            title_lbl.text = item.title
            price_lbl.text = "$" + String(item.price ?? 0)
        }
        
        if item.title == Constant.subtotal || item.title == Constant.total || item.title == Constant.processingFee{
            separatorView.isHidden = false
            delete_view.isHidden = true
            title_lbl.textColor = UIColor.black
            price_lbl.textColor = UIColor.black
        }
        else{
            separatorView.isHidden = true
            delete_view.isHidden = false
            title_lbl.textColor = UIColor.darkGray
            price_lbl.textColor = UIColor.darkGray
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        deletePressed.send(mItem)
    }
    
}
