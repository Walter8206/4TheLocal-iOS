//
//  BillingDetailVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 20/7/21.
//

import UIKit
import Combine
import SVProgressHUD

class BillingDetailVC: UIViewController {
    
    static let identifire = "BillingDetailVC"
    
    @IBOutlet weak var topNav: TopNavigation!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var firstName_tf: UITextField!
    @IBOutlet weak var lastName_tf: UITextField!
    @IBOutlet weak var company_tf: UITextField!
    @IBOutlet weak var country_tf: UITextField!
    @IBOutlet weak var address_tf: UITextField!
    @IBOutlet weak var city_tf: UITextField!
    @IBOutlet weak var state_tf: UITextField!
    @IBOutlet weak var zip_tf: UITextField!
    @IBOutlet weak var email_tf: UITextField!
    @IBOutlet weak var pass_tf: UITextField!
    @IBOutlet weak var phone_tf: UITextField!
    @IBOutlet weak var note_tf: UITextField!
    @IBOutlet weak var attachecImg: UIImageView!
    @IBOutlet weak var pt_title_lbl: UILabel!
    @IBOutlet weak var pt_desc_lbl: UILabel!
    @IBOutlet weak var attach_view: UIView!
    @IBOutlet weak var attach_view_height_cons: NSLayoutConstraint!
    
    
    var sc: SignupCredentials!
    var subscriptions = Set<AnyCancellable>()
    var imagePicker = UIImagePickerController()
    var isLogedinUser = false
    var isUpdateOnly = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isUpdateOnly{
            sc = SignupCredentials()
            continueBtn.setTitle("Update", for: .normal)
        }

        initView()
        setupNavView()
        
        if let cusId = MyUserDefaults.shared.getString(key: MyUserDefaults.cusIdKey){
            if MyUserDefaults.shared.getString(key: MyUserDefaults.tokenKey) != nil{
                self.getUserInfo(customerid: cusId)
            }
        }
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        SVProgressHUD().show()
        if checkValidation().count > 0{
            SVProgressHUD.dismiss()
            showAlert(msg: checkValidation())
            return
        }
        SVProgressHUD.dismiss()
        
        if isUpdateOnly{
            updateCustomer()
        }
        else{
            openPaymentDetailPage()
        }
        
    }
    
    @IBAction func pickTapped(_ sender: Any) {
        imagePick()
    }
    
}

extension BillingDetailVC{
    
    func initView(){
        topNav.rightBtn.isHidden = true
        topNav.titleLbl.text = "Billing Details"
        continueBtn.layer.cornerRadius = 13
        
        country_tf.text = "US"
        state_tf.text = "MI"
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            pt_title_lbl.isHidden = true
            pt_desc_lbl.isHidden = true
            pt_desc_lbl.text = ""
            attach_view.isHidden = true
            attach_view_height_cons.constant = 0
        }
        
//        firstName_tf?.text = "Pitter"
//        lastName_tf?.text = "Pot"
//        company_tf?.text = "P-Company"
//        address_tf?.text = "New Market"
//        city_tf?.text = "San Francisco"
//        zip_tf?.text = "94103"
//        phone_tf?.text = "(018) 111-1111"
//        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
//            email_tf?.text = "uu1@school.com"
//        }
//        else{
//            email_tf?.text = "uu1@business.com"
//        }
//        pass_tf?.text = "123321"
//        note_tf?.text = "Test Note"
    }
    
    func checkValidation()-> String{
        var msg = ""
        
        if (firstName_tf?.text!.count)! > 0{
            sc.first_name = firstName_tf.text!
        }
        else{
            msg = "First name is a required field."
            return msg
        }
        
        if (lastName_tf?.text!.count)! > 0{
            sc.last_name = lastName_tf.text!
        }
        else{
            msg = "Last name is a required field."
            return msg
        }
        
        if (country_tf?.text!.count)! > 0{
            sc.country = country_tf.text!
        }
        else{
            msg = "Country is a required field."
            return msg
        }
        
        if (address_tf?.text!.count)! > 0{
            sc.address = address_tf.text!
        }
        else{
            msg = "Street address is a required field."
            return msg
        }
        
        if (city_tf?.text!.count)! > 0{
            sc.city = city_tf.text!
        }
        else{
            msg = "City is a required field."
            return msg
        }
        
        if (state_tf?.text!.count)! > 0{
            sc.state = state_tf.text!
        }
        else{
            msg = "State is a required field."
            return msg
        }
        
        if (zip_tf?.text!.count)! > 0{
            sc.zip = zip_tf.text!
        }
        else{
            msg = "Zip is a required field."
            return msg
        }
        
        if (company_tf?.text!.count)! > 0{
            sc.company = company_tf.text!
        }
        else{

        }
        
        if (phone_tf?.text!.count)! > 0{
            sc.phone = phone_tf.text!
        }
        else{
            msg = "Phone Number is a required field."
            return msg
        }
        
        if (email_tf?.text!.count)! > 0{
            sc.email = email_tf.text!
            
            if !Bool().isValidEmail(sc.email){
                msg = "Email formate is not valid."
                return msg
            }
        }
        else{
            msg = "Email is a required field."
            return msg
        }
        
        if !isLogedinUser{
            if (pass_tf?.text!.count)! > 0{
                sc.password = pass_tf.text!
            }
            else{
                msg = "Password is a required field."
                return msg
            }
        }
        
        sc.notes =      note_tf.text ?? ""
        
        return msg
    }
    
    func setupNavView(){
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.navigationController?.popViewController(animated: true)
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        topNav.rightBtnPressed
            .handleEvents(receiveOutput: { newItem in
                
            })
            .sink{ _ in }
            .store(in: &subscriptions)
    }
    
    func openPaymentDetailPage(){
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: PaymentDetailVC.identifire) as? PaymentDetailVC
        vc?.signupCredentials = sc
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func setupFields(){
        DispatchQueue.main.async { [self] in
            if let userinfo = MyUserDefaults.shared.getUserInfo(){
                firstName_tf.text = userinfo.firstName
                lastName_tf.text = userinfo.lastName
                company_tf.text = userinfo.billing?.company
                address_tf.text = userinfo.billing?.address1
                city_tf.text = userinfo.billing?.city
                zip_tf.text = userinfo.billing?.postcode
                phone_tf.text = userinfo.billing?.phone
                email_tf.text = userinfo.billing?.email
                pass_tf.isHidden = true
                isLogedinUser = true
                
                self.sc?.customer_id = userinfo.id ?? -1
                if let billing = userinfo.billing{
                    self.sc?.billing = billing
                }
            }
        }
    }
}


extension BillingDetailVC{

    func imagePick() {
        ImagePickerManager().pickImage(self){ image in
            self.attachecImg.image = image
            AuthServices.shared.uploadImage(image: image)
        } 
    }
    
    func getUserInfo(customerid: String){
        SVProgressHUD().show()
        AuthServices.getUserInfo(customerId: customerid)
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
            } receiveValue: { [self] value in
                MyUserDefaults.shared.saveUserInfo(note: value)
                setupFields()
                SVProgressHUD.dismiss()
            }.store(in: &subscriptions)
    }
    
    func updateCustomer(){
        SVProgressHUD().show()
        AuthServices.shared.updateCustomer(vc: self, sc: sc)
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                debugPrint(value)
                self.sc.customer_id = value.id ?? -1
                if let billing = value.billing{
                    self.sc.billing = billing
                }
                SVProgressHUD.dismiss()
                self.navigationController?.popViewController(animated: true)
            }.store(in: &subscriptions)
    }
}
