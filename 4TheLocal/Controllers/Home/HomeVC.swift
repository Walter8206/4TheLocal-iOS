//
//  HomeVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 24/7/21.
//

import UIKit
import Combine

class HomeVC: UIViewController {
    
    static let identifire = "HomeVC"

    @IBOutlet weak var topNav: HomeTopNav!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var placeToSaveBtn: UIButton!
    @IBOutlet weak var chooseBtn: UIButton!
    @IBOutlet weak var plcToSaveBtn: UIButton!
    @IBOutlet weak var businessSignupBtn: UIButton!
    @IBOutlet weak var schoolSignupBtn: UIButton!
    @IBOutlet weak var myIdBtn: UIButton!
    @IBOutlet weak var app_img: UIImageView!
    @IBOutlet weak var school_btn_height_cons: NSLayoutConstraint!
    @IBOutlet weak var scl_btn_top_cons: NSLayoutConstraint!
    @IBOutlet weak var place_lbl: UILabel!
    @IBOutlet weak var exclusive_lbl: UILabel!
    @IBOutlet weak var place_height_cons: NSLayoutConstraint!
    
    @IBOutlet weak var sc_view_before_login: UIScrollView!
    @IBOutlet weak var sc_view_after_login: UIScrollView!
    
    
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        doAdminLogin()
        initView()
        
        if MyUserDefaults.shared.getString(key: MyUserDefaults.cusIdKey) == nil{
            sc_view_after_login.isHidden = true
            sc_view_before_login.isHidden = false
        }
        else{
            sc_view_after_login.isHidden = false
            sc_view_before_login.isHidden = true
        }
        
    }
    
    @IBAction func signupBtnTapped(_ sender: Any) {
        openPriceVc()
    }
    
    @IBAction func placeToSaveBtnTapped(_ sender: Any) {
        gotoLocationTab()
    }
    
    @IBAction func chooseBtnTapped(_ sender: Any) {
        openPriceVc()
    }
    
    
    @IBAction func placesToSaveTapped(_ sender: Any) {
        gotoLocationTab()
    }
    
    @IBAction func businessSignUpTapped(_ sender: Any) {
        //openBusinessSignUpPage()
        self.openOnBrowser(link: Constant.shared.businessSignupLink)
    }
    
    @IBAction func schoolSignUpTapped(_ sender: Any) {
        //openBusinessSignUpPage()
        self.openOnBrowser(link: Constant.shared.schoolSignupLink)
    }
    
    @IBAction func myIdTapped(_ sender: Any) {
        gotoAccTab()
    }
    
    
}

extension HomeVC{
    
    func initView(){
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            topNav.titleLbl.text = "4TheLocal School"
        }
        else{
            topNav.titleLbl.text = "4TheLocal"
        }
        
        signUpBtn.layer.cornerRadius = 5
        placeToSaveBtn.layer.cornerRadius = 5
        placeToSaveBtn.layer.borderWidth = 1
        placeToSaveBtn.layer.borderColor = UIColor.white.cgColor
        chooseBtn.layer.cornerRadius = 13
        
        plcToSaveBtn.layer.cornerRadius = 13
        businessSignupBtn.layer.cornerRadius = 13
        schoolSignupBtn.layer.cornerRadius = 13
        myIdBtn.layer.cornerRadius = 13
        
        topNav.menuBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.sideMenuController?.revealMenu()

            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            app_img.image = UIImage(named: "scl_app_img")
            schoolSignupBtn.isHidden = false
            school_btn_height_cons.constant = 56
            scl_btn_top_cons.constant = 20
            place_lbl.isHidden = true
            exclusive_lbl.text = "AN EXCLUSIVE"
            place_height_cons.constant = 0
        }
        else{
            app_img.image = UIImage(named: "app_img")
            schoolSignupBtn.isHidden = true
            school_btn_height_cons.constant = 0
            scl_btn_top_cons.constant = 0
            place_lbl.isHidden = false
            exclusive_lbl.text = "EXCLUSIVE"
        }
    }
    
    func gotoLocationTab(){
        self.tabBarController?.selectedIndex = 1
    }

    func gotoAccTab(){
        self.tabBarController?.selectedIndex = 2
    }
    
    func openPriceVc(){
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: PricingVC.identifire) as! PricingVC
        vc.isFromHomeAndSkip = true
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isNavigationBarHidden = true
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true, completion: nil)
    }
    
    func doAdminLogin(){
        AuthServices.loginApi(vc: self, Constant.shared.getAdminUser(), Constant.shared.getAdminPass())
            .receive(on: DispatchQueue.main)
            .sink { response in

            } receiveValue: { value in
                MyUserDefaults.shared.saveString(key: MyUserDefaults.tokenKey, value: value.token)
                
            }.store(in: &subscriptions)
    }
    
    func openBusinessSignUpPage(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: BusinessSignupVC.identifire) as? BusinessSignupVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
