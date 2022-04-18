//
//  AccEditVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 20/8/21.
//

import UIKit
import Combine
import SVProgressHUD

class AccEditVC: UIViewController {
    
    static let identifire = "AccEditVC"
    
    @IBOutlet weak var topNav: TopNavigation!
    @IBOutlet weak var displayName_tf: UITextField!
    @IBOutlet weak var email_tf: UITextField!
    @IBOutlet weak var pass_tf: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    var subscriptions: Set<AnyCancellable> = []
    var userInfo: UserInfoResponse!
    var sc = SignupCredentials()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupNavView()
    }

    @IBAction func saveTapped(_ sender: Any) {
        let fullName    = displayName_tf.text ?? ""
        let fullNameArr = fullName.components(separatedBy: " ")
        let fName    = fullNameArr[0]
        let lName = fullNameArr[1]
        
        sc.first_name = fName
        sc.last_name = lName
        sc.email = email_tf.text ?? ""
        sc.password = pass_tf.text ?? ""
        
        if let userInfo = MyUserDefaults.shared.getUserInfo(){
            sc.customer_id = userInfo.id ?? 0
            if let billing = userInfo.billing{
                sc.company = billing.company ?? ""
                sc.address = billing.address1 ?? ""
                sc.city = billing.city ?? ""
                sc.state = billing.state ?? ""
                sc.zip = billing.postcode ?? ""
                sc.country = billing.country ?? ""
                sc.email = email_tf.text ?? ""
                sc.phone = billing.phone ?? ""
            }
        }
        
        
        updateCustomer()
    }
    
}


extension AccEditVC{
    func initView(){
        saveBtn.layer.cornerRadius = 10
        
        if let userInfo = MyUserDefaults.shared.getUserInfo(){
            displayName_tf.text = (userInfo.firstName ?? "") + " " + (userInfo.lastName ?? "")
            email_tf.text = userInfo.email
        }
    }
    
    func setupNavView(){
        topNav.titleLbl.text = "Account Detail"
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.navigationController?.popViewController(animated: true)
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        topNav.rightBtnPressed
            .handleEvents(receiveOutput: { [self] newItem in
                openFaqPage()
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
    
    func openFaqPage(){
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: WebviewVC.identifire) as? WebviewVC
        vc?.titleTxt = "FAQ"
        vc?.link = Constant.shared.faq
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func updateCustomer(){
        SVProgressHUD().show()
        AuthServices.shared.updateCustomer(vc: self, sc: sc)
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                debugPrint(value)
                SVProgressHUD.dismiss()
                if let cusId = value.id{
                    self.getUserInfo(cusId: String(cusId))
                }
                
            }.store(in: &subscriptions)
    }
    
    func getUserInfo(cusId: String){
        SVProgressHUD().show()
        AuthServices.getUserInfo(customerId: cusId)
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                MyUserDefaults.shared.saveUserInfo(note: value)
                SVProgressHUD.dismiss()
                self.initView()
            }.store(in: &subscriptions)
    }
}
