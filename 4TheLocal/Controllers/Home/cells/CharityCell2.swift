//
//  CharityCell2.swift
//  4TheLocal
//
//  Created by Mahamudul on 25/7/21.
//

import UIKit

class CharityCell2: UITableViewCell {
    
    @IBOutlet weak var item_img: UIImageView!
    @IBOutlet weak var title_lb: UILabel!
    @IBOutlet weak var city_lb: UILabel!
    @IBOutlet weak var discount_lb: UILabel!
    
    static let identifire = "CharityCell2"
    
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
        resetViews()
        guard let url = item.acf.image.url else { return }
        HomeServices.loadImage(imageView: item_img, urlStr: url)
        title_lb.setHTMLFromString(htmlText: item.title.rendered ?? "")
        discount_lb.text = item.acf.acfDescription
    }
    
    
    func resetViews(){
        item_img.image = UIImage()
        title_lb.text = ""
        discount_lb.text = ""
    }
}
