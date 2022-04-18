//
//  AddressCell.swift
//  4TheLocal
//
//  Created by Mahamudul on 21/8/21.
//

import UIKit
import Combine

class AddressCell: UITableViewCell {
    
    static let identifire = "AddressCell"
    
    static func nib() -> UINib{
        return UINib(nibName: identifire, bundle: nil)
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    
    let editPressed = PassthroughSubject<UserInfoResponse?, Never>()
    var data: UserInfoResponse!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(user: UserInfoResponse){
        data = user
        name.text = (user.billing?.firstName ?? "") + " " + (user.billing?.lastName ?? "")
        address.text = user.billing?.address1
    }
    
    
    @IBAction func editTapped(_ sender: Any) {
        if let userRes = data{
            editPressed.send(userRes)
        }
    }
    
}
