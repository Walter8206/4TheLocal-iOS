//
//  StartPageVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 28/6/21.
//

import UIKit
import Combine
import SVProgressHUD

class StartPageVC: UIViewController {
    
    static let identifire = "StartPageVC"
    
    @IBOutlet weak var localBtn: UIButton!
    @IBOutlet weak var schoolBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.roudCorners(radius: 10)
        continueBtn.alpha = 0.5
        continueBtn.isEnabled = false
    }
    
    
    @IBAction func localBtnTapped(_ sender: Any) {
        selectLocalBtn()
    }
    
    @IBAction func schoolBtnTapped(_ sender: Any) {
        selectSchoolBtn()
    }
    
    
    @IBAction func continueBtnTapped(_ sender: Any) {
        doAdminLogin()
    }
    
    
}

extension StartPageVC{
    
    func selectBtn(btn: UIButton){
        btn.addShadow()
    }
    
    func deselectBtn(btn: UIButton){
        btn.removeShadow()
    }
    
    func openLoginPage(){
        
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: LoginVC.identifire) as? LoginVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func selectLocalBtn(){
        localBtn.addShadow()
        schoolBtn.removeShadow()
        localBtn.setImage(UIImage(named: "local_selected_bg"), for: .normal)
        schoolBtn.setImage(UIImage(named: "school_normal_bg"), for: .normal)
        MyUserDefaults.shared.saveBool(key: MyUserDefaults.isSchoolKey, value: false)
        enableContinueBtn()
    }
    
    func selectSchoolBtn(){
        localBtn.removeShadow()
        schoolBtn.addShadow()
        localBtn.setImage(UIImage(named: "local_normal_bg"), for: .normal)
        schoolBtn.setImage(UIImage(named: "school_selected_bg"), for: .normal)
        MyUserDefaults.shared.saveBool(key: MyUserDefaults.isSchoolKey, value: true)
        enableContinueBtn()
    }
    
    func enableContinueBtn(){
        continueBtn.alpha = 1
        continueBtn.isEnabled = true
        continueBtn.setTitle("Continue", for: .normal)
    }
    
    func disableContinueBtn(){
        continueBtn.alpha = 0.5
        continueBtn.isEnabled = false
        continueBtn.setTitle("Continue", for: .normal)
    }
    
    
    func doAdminLogin(){
        if let img =  UIImage(named: "default_pic"){
            ImagePickerManager.saveImage(image: img)
        }
        SVProgressHUD().show()
        AuthServices.loginApi(vc: self, Constant.shared.getAdminUser(), Constant.shared.getAdminPass())
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
            } receiveValue: {[self] value in
                MyUserDefaults.shared.saveString(key: MyUserDefaults.tokenKey, value: value.token)
                openLoginPage()
                SVProgressHUD.dismiss()
            }.store(in: &subscriptions)
    }
}

