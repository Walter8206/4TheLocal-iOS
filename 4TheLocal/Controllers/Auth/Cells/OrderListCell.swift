//
//  OrderListCell.swift
//  4TheLocal
//
//  Created by Mahamudul on 21/8/21.
//

import UIKit

class OrderListCell: UITableViewCell {
    
    static let identifire = "OrderListCell"
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
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
    
    func configure(item: Order){
        //let url = item.acf.image.url
        titleLbl.text = "Order Id: #" + String(item.id ?? 0)
        descLbl.text = "Status: \(item.status ?? "")"
    }
    
}
