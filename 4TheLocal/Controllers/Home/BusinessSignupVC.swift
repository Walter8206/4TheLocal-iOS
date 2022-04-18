//
//  BusinessSignupVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 25/7/21.
//

import UIKit
import Combine
import SVProgressHUD
import WebKit

class BusinessSignupVC: UIViewController {
    
    static let identifire = "BusinessSignupVC"
    
    @IBOutlet weak var topNav: HomeTopNav!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var signupScView: UIScrollView!
    @IBOutlet weak var firstname_tf: UITextField!
    @IBOutlet weak var lastname_tf: UITextField!
    @IBOutlet weak var email_tf: UITextField!
    @IBOutlet weak var phone_tf: UITextField!
    @IBOutlet weak var cell_phone_tf: UITextField!
    @IBOutlet weak var name_tf: UITextField!
    @IBOutlet weak var discount_tf: UITextField!
    @IBOutlet weak var address_tf: UITextField!
    @IBOutlet weak var city_tf: UITextField!
    @IBOutlet weak var state_tf: UITextField!
    @IBOutlet weak var zip_tf: UITextField!
    @IBOutlet weak var description_tf: UITextField!
    @IBOutlet weak var businessType_tf: UITextField!
    @IBOutlet weak var website_tf: UITextField!
    @IBOutlet weak var facebook_tf: UITextField!
    @IBOutlet weak var instagram_tf: UITextField!
    @IBOutlet weak var webView: WKWebView!
    
    var subscriptions = Set<AnyCancellable>()
    var bData: BusinessSignUpData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        
        if checkValidation().count > 0{
            showAlert(msg: checkValidation())
            return
        }
        signupBusiness()
    }
    
}

extension BusinessSignupVC{
    
    func initView(){
        
        let link = URL(string: Constant.shared.benefits)!
        let request = URLRequest(url: link)
        webView.load(request)
        webView.isHidden = true
        
        bData = BusinessSignUpData()
        topNav.menuBtnWidthCons.constant = 63
        topNav.toggleBtnView.isHidden = false
        topNav.titleLbl.isHidden = true
        topNav.leftBtn.setTitle("Signup", for: .normal)
        topNav.rightBtn.setTitle("Benefits", for: .normal)
        self.signupScView.isHidden = false
        
        submitBtn.layer.cornerRadius = 13
        
        topNav.menuBtn.setImage(UIImage(named: "back_btn"), for: .normal)
        topNav.menuBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.navigationController?.popViewController(animated: true)
                
            })
            .sink{ _ in }
            .store(in: &subscriptions)
        
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                
                self.signupScView.isHidden = false
                self.webView.isHidden = true
            })
            .sink{ _ in }
            .store(in: &subscriptions)
        
        topNav.rightBtnPressed
            .handleEvents(receiveOutput: { [self] newItem in
                
                self.signupScView.isHidden = true
                self.webView.isHidden = false
            })
            .sink{ _ in }
            .store(in: &subscriptions)
        
        
//        firstname_tf.text = "Sijan"
//        lastname_tf.text = "sd"
//        email_tf.text = "sd2@company.com"
//        phone_tf.text = "123123123"
//        cell_phone_tf.text = "123123123"
//        name_tf.text = "Sd Business"
//        discount_tf.text = "sd discount"
//        address_tf.text = "sd address"
//        city_tf.text = "sd city"
//        state_tf.text = "sd state"
//        zip_tf.text = "123123"
//        description_tf.text = "sd desc"
//        businessType_tf.text = "Restaurant"
//        website_tf.text = "www.webside.com"
//        facebook_tf.text = "www.facebook.com"
//        instagram_tf.text = "www.instagram.com"
    }
    
    
    func signupBusiness(){
        SVProgressHUD().show()
        HomeServices.shared.signUpBusiness(vc: self, bData: bData)
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                debugPrint(value)
                SVProgressHUD.dismiss()
            }.store(in: &subscriptions)
    }
    
    
    func checkValidation()-> String{
        var msg = ""
        
        if (firstname_tf?.text!.count)! > 0{
            bData.firstname = firstname_tf?.text ?? ""
        }
        else{
            msg = "First name field is required"
            return msg
        }
        if (lastname_tf?.text!.count)! > 0{
            bData.lastname = lastname_tf?.text ?? ""
        }
        else{
            msg = "Last name field is required"
            return msg
        }
        if (phone_tf?.text!.count)! > 0{
            bData.phone = phone_tf?.text ?? ""
        }
        else{
            msg = "Phone field is required"
            return msg
        }
        if (cell_phone_tf?.text!.count)! > 0{
            bData.cell_phone = cell_phone_tf?.text ?? ""
        }
        else{
            msg = "Cell Phone field is required"
            return msg
        }
        if (email_tf?.text!.count)! > 0{
            bData.email = email_tf?.text ?? ""
        }
        else{
            msg = "Email field is required"
            return msg
        }
        if (discount_tf?.text!.count)! > 0{
            bData.discount = discount_tf?.text ?? ""
        }
        else{
            msg = "Discount field is required"
            return msg
        }
        if (address_tf?.text!.count)! > 0{
            bData.address = address_tf?.text ?? ""
        }
        else{
            msg = "Address field is required"
            return msg
        }
        if (city_tf?.text!.count)! > 0{
            bData.city = city_tf?.text ?? ""
        }
        else{
            msg = "City field is required"
            return msg
        }
        if (state_tf?.text!.count)! > 0{
            bData.state = state_tf?.text ?? ""
        }
        else{
            msg = "State field is required"
            return msg
        }
        if (zip_tf?.text!.count)! > 0{
            bData.zip = zip_tf?.text ?? ""
        }
        else{
            msg = "Zip field is required"
            return msg
        }
        if (description_tf?.text!.count)! > 0{
            bData.description = description_tf?.text ?? ""
        }
        else{
            msg = "Description field is required"
            return msg
        }
        if (businessType_tf?.text!.count)! > 0{
            bData.businessType = businessType_tf?.text ?? ""
        }
        else{
            msg = "Business Type field is required"
            return msg
        }
        
        return msg
    }
}
