//
//  SortVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 19/8/21.
//

import UIKit
import Combine

class SortVC: UIViewController {
    
    static let identifire = "SortVC"
    
    
    @IBOutlet weak var new_img: UIImageView!
    @IBOutlet weak var asc_img: UIImageView!
    @IBOutlet weak var dsc_img: UIImageView!
    
    let itemSelect = PassthroughSubject<Int?, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let type = MyUserDefaults.shared.getInt(key: MyUserDefaults.sortTypeKey){
            if type == 2{
                selectAsc()
            }
            else if type == 3{
                selectDsc()
            }
            else{
                selectNew()
            }
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newListingTapped(_ sender: Any) {
        selectNew()
        itemSelect.send(1)
    }
    
    @IBAction func ascTapped(_ sender: Any) {
        selectAsc()
        itemSelect.send(2)
    }
    
    @IBAction func dscTapped(_ sender: Any) {
        selectDsc()
        itemSelect.send(3)
    }
    
    
    func selectNew(){
        new_img.image = UIImage(named: "radio_select")
        asc_img.image = UIImage(named: "radio_deselect")
        dsc_img.image = UIImage(named: "radio_deselect")
        MyUserDefaults.shared.saveInt(key: MyUserDefaults.sortTypeKey, value: 1)
        
        dismiss(animated: true, completion: nil)
    }
    
    func selectAsc(){
        new_img.image = UIImage(named: "radio_deselect")
        asc_img.image = UIImage(named: "radio_select")
        dsc_img.image = UIImage(named: "radio_deselect")
        MyUserDefaults.shared.saveInt(key: MyUserDefaults.sortTypeKey, value: 2)
        
        dismiss(animated: true, completion: nil)
    }
    
    func selectDsc(){
        new_img.image = UIImage(named: "radio_deselect")
        asc_img.image = UIImage(named: "radio_deselect")
        dsc_img.image = UIImage(named: "radio_select")
        MyUserDefaults.shared.saveInt(key: MyUserDefaults.sortTypeKey, value: 3)
        
        dismiss(animated: true, completion: nil)
    }
    
}
