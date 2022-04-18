//
//  FilterVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 15/8/21.
//

import UIKit
import Combine

class FilterVC: UIViewController {
    
    static let identifire = "FilterVC"
    
    @IBOutlet weak var business_lbl: UILabel!
    @IBOutlet weak var city_lbl: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    
    let applySelect = PassthroughSubject<FilterDate?, Never>()
    let resetSelect = PassthroughSubject<String?, Never>()
    var cityList: [String]!
    var businessTypes: [String]!
    var typesTxt: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func businessTapped(_ sender: Any) {
        guard self.businessTypes.count > 0 else {
            return
        }
        showCityList(list: businessTypes)
    }
    
    @IBAction func cityTapped(_ sender: Any) {
        guard self.cityList.count > 0 else {
            return
        }
        showCityList(list: cityList, isCity: true)
    }
    
    @IBAction func applyTapped(_ sender: Any) {
        let filterData = FilterDate()
        
        if let business = MyUserDefaults.shared.getString(key: MyUserDefaults.businessFilterKey){
            filterData.business = business
        }
        if let city = MyUserDefaults.shared.getString(key: MyUserDefaults.cityFilterKey){
            filterData.city = city
        }
        
        
        if filterData.business == Constant.filterBusinessTitle{
            filterData.business = nil
        }
        
        if filterData.business == Constant.filterCharityTitle{
            filterData.business = nil
        }
        
        if filterData.city == Constant.filterCityTitle{
            filterData.city = nil
        }
        
        applySelect.send(filterData)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        if let types = typesTxt{
            business_lbl.text = types
        }
        else{
            business_lbl.text = "All Business types"
        }
        city_lbl.text = "All Cities"
        
        MyUserDefaults.shared.saveString(key: MyUserDefaults.cityFilterKey, value: nil)
        MyUserDefaults.shared.saveString(key: MyUserDefaults.businessFilterKey, value: nil)
    }
    
}


extension FilterVC{
    
    func initView(){
        if let types = typesTxt{
            business_lbl.text = types
        }
        else{
            business_lbl.text = Constant.filterBusinessTitle
        }
        
        if let city = MyUserDefaults.shared.getString(key: MyUserDefaults.cityFilterKey){
            city_lbl.text = city
        }
        if let business = MyUserDefaults.shared.getString(key: MyUserDefaults.businessFilterKey){
            business_lbl.text = business
        }
        applyBtn.layer.cornerRadius = 8
        resetBtn.layer.cornerRadius = 8
        resetBtn.layer.borderWidth = 1
        resetBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    func showCityList(list: [String], isCity: Bool = false){
        
        let refreshAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)

        for title in list{
            refreshAlert.addAction(UIAlertAction(title: title, style: .default, handler: { [self] (action: UIAlertAction!) in
                
                if isCity{
                    city_lbl.text = title
                    MyUserDefaults.shared.saveString(key: MyUserDefaults.cityFilterKey, value: title)
                }
                else{
                    business_lbl.text = title
                    MyUserDefaults.shared.saveString(key: MyUserDefaults.businessFilterKey, value: title)
                }
               
            }))
        }
        present(refreshAlert, animated: true, completion: {
            refreshAlert.view.superview?.isUserInteractionEnabled = true
            refreshAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
}


class FilterDate{
    var business: String?
    var city: String?
}
