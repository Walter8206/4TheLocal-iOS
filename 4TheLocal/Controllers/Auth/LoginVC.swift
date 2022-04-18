//
//  LoginVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 1/7/21.
//

import UIKit
import Combine
import SVProgressHUD

class LoginVC: UIViewController {
    
    static let identifire = "LoginVC"
    
    @IBOutlet weak var lgoinBtn: UIButton!
    @IBOutlet weak var accCreateBtn: UIButton!
    @IBOutlet weak var businessSignUpBtn: UIButton!
    @IBOutlet weak var schoolSignUpBtn: UIButton!
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var email_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    @IBOutlet weak var selectType_img: UIImageView!
    @IBOutlet weak var topNav: TopNavigation!
    
    var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //doAdminLogin()
        initViews()
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        //openHomePage()
        if checkValidation().count > 0{
            showAlert(msg: checkValidation())
            return
        }
        
        let email = email_tf?.text ?? ""
        let pass = password_tf?.text ?? ""
        if email.count > 0 && pass.count > 4 {
            requestLoginApi(email, pass)
        }
        
    }
    
    @IBAction func accCreateBtnTapped(_ sender: Any) {
        MyUserDefaults.shared.clearAll()
        openPricingPage()
    }
    
    @IBAction func forgorpassTapped(_ sender: Any) {
        openForgotPassPage()
    }
    
    @IBAction func businessSignUpTapped(_ sender: Any) {
        openBusinessSignUpPage()
    }
    
    @IBAction func schoolSignUpTapped(_ sender: Any) {
        openSchoolSignUpPage()
    }
}


extension LoginVC{
    
    func initViews(){
        setupNavView()
//        email_tf.text = "u2@school.com"
//        password_tf.text = "123321"
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            selectType_img.image = UIImage(named: "school_selected_bg")
        }
        else{
            selectType_img.image = UIImage(named: "local_selected_bg")
        }
        
        lgoinBtn.layer.cornerRadius = 13
        accCreateBtn.layer.borderWidth = 0.5
        accCreateBtn.layer.borderColor = UIColor.black.cgColor
        accCreateBtn.layer.cornerRadius = 13
        
        businessSignUpBtn.layer.borderWidth = 0.5
        businessSignUpBtn.layer.borderColor = UIColor.black.cgColor
        businessSignUpBtn.layer.cornerRadius = 13
        
        schoolSignUpBtn.layer.borderWidth = 0.5
        schoolSignUpBtn.layer.borderColor = UIColor.black.cgColor
        schoolSignUpBtn.layer.cornerRadius = 13
        
        if !MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            schoolSignUpBtn.isHidden = true
        }
    }
    
    func openPricingPage(){
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: PricingVC.identifire) as? PricingVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func openForgotPassPage(){
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: ForgotPassVC.identifire) as? ForgotPassVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func openBusinessSignUpPage(){
     self.openOnBrowser(link: Constant.shared.businessSignupLink)
    }
    
    func openSchoolSignUpPage(){
        self.openOnBrowser(link: Constant.shared.schoolSignupLink)
    }
    
    func openHomePage(){
        let mySceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        mySceneDelegate.openHomePage()
    }
    
    func requestLoginApi(_ email: String, _ pass: String){
        SVProgressHUD().show()
        AuthServices.loginApi(vc: self, email, pass)
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                
                SVProgressHUD.dismiss()
                MyUserDefaults.shared.saveString(key: MyUserDefaults.userTokenKey, value: value.token)
                MyUserDefaults.shared.saveString(key: MyUserDefaults.emailKey, value: value.userEmail)
                MyUserDefaults.shared.saveString(key: MyUserDefaults.nameKey, value: value.userDisplayName)
                MyUserDefaults.shared.saveInt(key: MyUserDefaults.cusIdKey, value: value.id!)
                
                
                self.openHomePage()
                
            }.store(in: &subscriptions)
    }
}


extension LoginVC{
    
    func setupNavView(){
        topNav.view.backgroundColor = UIColor.clear
        topNav.titleLbl.text = "Login"
        topNav.rightBtn.isHidden = false
        topNav.rightBtn.setTitle("Skip", for: .normal)
        
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.navigationController?.popViewController(animated: true)
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        topNav.rightBtnPressed
            .handleEvents(receiveOutput: { [self] newItem in
                
//                MyUserDefaults.shared.saveBool(key: MyUserDefaults.isLoginKey, value: true)
                
                openHomePage()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                    MyUserDefaults.shared.saveBool(key: MyUserDefaults.isLoginKey, value: false)
                }
            })
            .sink{ _ in }
            .store(in: &subscriptions)
    }
    
    func checkValidation()-> String{
        var msg = ""
        
        if (email_tf?.text!.count)! == 0{
            msg = "Username is required."
            return msg
        }
        else if (password_tf?.text!.count)! == 0{
            msg = "The password field is empty."
            return msg
        }
        
        return msg
    }
    
}
