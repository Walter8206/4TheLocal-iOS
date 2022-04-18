//
//  ForgotPassVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 25/8/21.
//

import UIKit
import Combine
import SVProgressHUD

class ForgotPassVC: UIViewController {
    static let identifire = "ForgotPassVC"
    
    @IBOutlet weak var topNav: TopNavigation!
    @IBOutlet weak var email_tf: UITextField!
    @IBOutlet weak var send_btn: UIButton!
    
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupNavView()
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        
        if Bool().isValidEmail(email_tf.text!){
            requestForgotpass(email_tf.text!)
        }
        else{
            showAlert(msg: "Email formate is not valid.")
        }
    }
}


extension ForgotPassVC{
    
    func initView(){
        send_btn.layer.cornerRadius = 13
    }
    
    func setupNavView(){
        topNav.view.backgroundColor = UIColor.clear
        topNav.titleLbl.text = "Forgot Password"
        topNav.rightBtn.isHidden = true
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.navigationController?.popViewController(animated: true)
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
    
    func requestForgotpass(_ email: String){
        SVProgressHUD().show()
        AuthServices.forgotPass(vc: self, email: email)
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                debugPrint(value)
                SVProgressHUD.dismiss()
            }.store(in: &subscriptions)
    }
}
