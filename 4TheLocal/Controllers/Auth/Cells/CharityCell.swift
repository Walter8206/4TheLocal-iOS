//
//  CharityCell.swift
//  4TheLocal
//
//  Created by Mahamudul on 19/7/21.
//

import UIKit

class CharityCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    static let identifire = "CharityCell"
    
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
    
    func configure(item: CharityResponseElement){
        //let url = item.acf.image.url
        titleLbl.text = item.title.rendered
        descLbl.text = item.acf.acfDescription
    }
}
