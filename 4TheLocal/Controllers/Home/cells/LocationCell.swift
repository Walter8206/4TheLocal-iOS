//
//  LocationCell.swift
//  4TheLocal
//
//  Created by Mahamudul on 25/7/21.
//

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var item_img: UIImageView!
    @IBOutlet weak var title_lb: UILabel!
    @IBOutlet weak var city_lb: UILabel!
    @IBOutlet weak var discount_lb: UILabel!
    
    static let identifire = "LocationCell"
    
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
    
    func configure(item: BusinessResponseElement){
        resetViews()
        if let url = item.acf?.image?.url{
            HomeServices.loadImage(imageView: item_img, urlStr: url)
        }
        item_img.layer.cornerRadius = 10
        title_lb.setHTMLFromString(htmlText: item.title?.rendered ?? "")
        city_lb.text = item.acf?.city
        discount_lb.text = item.acf?.discount
    }
    
    func resetViews(){
        item_img.image = UIImage()
        title_lb.text = ""
        city_lb.text = ""
        discount_lb.text = ""
    }
    
}
