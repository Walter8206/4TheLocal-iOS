//
//  AccViewCell.swift
//  4TheLocal
//
//  Created by Mahamudul on 10/8/21.
//

import UIKit

class AccViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!
    
    static let identifire = "AccViewCell"
    
    
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
    
    func configure(name: String){
        nameLbl?.text = name
    }
    
    func setLblColor(color: UIColor){
        nameLbl.textColor = color
    }
    
    func hideArrow(){
        arrowImg.isHidden = true
    }
    
}
