//
//  PricingVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 4/7/21.
//

import UIKit
import Combine
import SVProgressHUD

class PricingVC: UIViewController {

    static let identifire = "PricingVC"
    var isFromHomeAndSkip: Bool = false
    
    @IBOutlet weak var verticalStack: UIStackView!
    @IBOutlet weak var topNav: TopNavigation!
    @IBOutlet weak var desc_lbl: UILabel!
    
    
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            getAllSchoolProducts()
        }
        else{
            getAllProducts()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        verticalStack.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }

}


extension PricingVC{
    
    func initView(){
        topNav?.titleLbl.text = "Pricing"
        self.verticalStack.spacing = 10
        self.verticalStack.distribution = .equalSpacing
        
        setupNavView()
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            desc_lbl.text = "Your DIGITAL ID is good for one year from time of purchase"
        }
    }
    
    func addAnnualView(data: AllProductsResponse){
        let mView = AnnualPricingView(frame: .zero)
        mView.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.addArrangedSubview(mView)
        mView.configure(data: data)
        mView.signup.handleEvents(receiveOutput: { [unowned self] newItem in
            if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
                self.openBoosterPage(sc: newItem)
            }
            else{
                self.openCharityPage(sc: newItem)
            }
        })
        .sink { _ in }
        .store(in: &subscriptions)
    }
    
    func addGiftView(data: AllProductsResponse){
        let mView = GiftPricingView(frame: .zero)
        mView.translatesAutoresizingMaskIntoConstraints = false
        mView.configure(data: data)
        mView.giftSignup.handleEvents(receiveOutput: { [unowned self] newItem in
            self.openBillingPage(sc: newItem)
        })
        .sink { _ in }
        .store(in: &subscriptions)
        verticalStack.addArrangedSubview(mView)
        //verticalStack.layoutIfNeeded()
    }
    
    func addParttimeView(data: AllProductsResponse){
        let mView = ParttimePricingView(frame: .zero)
        mView.translatesAutoresizingMaskIntoConstraints = false
        mView.configure(data: data)
        mView.signup.handleEvents(receiveOutput: { [unowned self] newItem in
            self.openBillingPage(sc: newItem)
        })
        .sink { _ in }
        .store(in: &subscriptions)
        verticalStack.addArrangedSubview(mView)
        //verticalStack.layoutIfNeeded()
    }
    
    func addMoreView(){
        let mView = MoreView(frame: .zero)
        mView.translatesAutoresizingMaskIntoConstraints = false
        mView.moreBtnPressed.handleEvents(receiveOutput: { [unowned self] newItem in
            if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
                //self.openBoosterPage(sc: newItem)
            }
            else{
                self.openCharityPage()
            }
        })
        .sink { _ in }
        .store(in: &subscriptions)
        verticalStack.addArrangedSubview(mView)
        //verticalStack.layoutIfNeeded()
    }
}


extension PricingVC{
    
    func setupNavView(){
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { [self] newItem in
                Constant.OrderItemList.removeAll()
                if isFromHomeAndSkip{
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    self.navigationController?.popViewController(animated: true)
                }
                
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        topNav.rightBtnPressed
            .handleEvents(receiveOutput: { [self] newItem in
                openFaqPage()
            })
            .sink{ _ in }
            .store(in: &subscriptions)
    }
    
    func openCharityPage(sc: SignupCredentials){
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: CharityListVC.identifire) as? CharityListVC
        vc?.sc = sc
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func openBillingPage(sc: SignupCredentials){
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: BillingDetailVC.identifire) as? BillingDetailVC
        vc?.sc = sc
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func openFaqPage(){
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: WebviewVC.identifire) as? WebviewVC
        vc?.titleTxt = "FAQ"
        vc?.link = Constant.shared.faq
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func openCharityPage(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: CharityVC.identifire) as? CharityVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func openBoosterPage(sc: SignupCredentials){
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: BoosterPageVC.identifire) as? BoosterPageVC
        vc?.sc = sc
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getAllProducts(){
        SVProgressHUD().show()
        AuthServices.getAllProducts()
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
            } receiveValue: { value in
                //debugPrint(value)
                
                self.addAnnualView(data: value)
                
                let product1 = value.products.filter{$0.title == "Membership with Coupon"}
                if (product1.first?.price) != nil{
                    self.addGiftView(data: value)
                }
                
                let product2 = value.products.filter{$0.title == "PT Resident Digital ID"}
                if (product2.first?.price) != nil{
                    self.addParttimeView(data: value)
                }
                
                if !MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
                    self.addMoreView()
                }
                
                
                SVProgressHUD.dismiss()
            }.store(in: &subscriptions)
    }
    
    
    func getAllSchoolProducts(){
        SVProgressHUD().show()
        AuthServices.getAllProducts()
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
            } receiveValue: { value in
                //debugPrint(value)
                
                self.addAnnualView(data: value)
                
                let product1 = value.products.filter{$0.title == "Annual Membership Gift Certificate"}
                if (product1.first?.price) != nil{
                    self.addGiftView(data: value)
                }
                
//                let product2 = value.products.filter{$0.title == "Annual Membership Gift Certificate"}
//                if (product2.first?.price) != nil{
//                    self.addParttimeView(data: value)
//                }
                
                if !MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
                    self.addMoreView()
                }
                
                
                SVProgressHUD.dismiss()
            }.store(in: &subscriptions)
    }
    
}
