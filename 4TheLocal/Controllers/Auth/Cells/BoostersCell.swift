//
//  BoostersCell.swift
//  4TheLocal
//
//  Created by Mahamudul on 12/9/21.
//

import UIKit
import Combine

class BoostersCell: UITableViewCell {
    
    static let identifire = "BoostersCell"
    
    @IBOutlet weak var check_img: UIImageView!
    @IBOutlet weak var title_lbl: UILabel!
    
    let itemClick = PassthroughSubject<BoosterSelectClass?, Never>()
    
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
    
    
    func configure(item: BoostersResponseElement){
        resetView()
        title_lbl?.text = item.booster
    }
    
    func configureStudent(name: Student){
        resetView()
        title_lbl?.text = (name.firstName ?? "") + " " + (name.lastName ?? "")
    }
    
    func selectItem(){
        if check_img.image == UIImage(named: "radio_deselect"){
            check_img.image = UIImage(named: "radio_select")
            
            let boosterClass = BoosterSelectClass()
            boosterClass.isSelect = true
            boosterClass.name = title_lbl.text
            itemClick.send(boosterClass)
        }
        else{
            check_img.image = UIImage(named: "radio_deselect")
            let boosterClass = BoosterSelectClass()
            boosterClass.isSelect = false
            boosterClass.name = title_lbl.text
            itemClick.send(boosterClass)
        }
        
    }
    
    func resetView(){
        check_img.image = UIImage(named: "radio_deselect")
        title_lbl.text = ""
    }
}


class BoosterSelectClass{
    var isSelect = false
    var name: String!
}
