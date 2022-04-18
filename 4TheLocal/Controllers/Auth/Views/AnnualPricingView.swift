//
//  AnnualPricingCell.swift
//  4TheLocal
//
//  Created by Mahamudul on 4/7/21.
//

import UIKit
import Combine

class AnnualPricingView: UIView {
    
    private static let NIB_NAME = "AnnualPricingView"
    
    @IBOutlet var container: UIView!
    @IBOutlet weak var leftPriceView: UIView!
    @IBOutlet weak var middlePriceView: UIView!
    @IBOutlet weak var rightPriceView: UIView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var leftBgImg: UIImageView!
    @IBOutlet weak var middleBgImg: UIImageView!
    @IBOutlet weak var rightBgImg: UIImageView!
    @IBOutlet weak var annualPriceLbl: UILabel!
    @IBOutlet weak var quartlyPriceLbl: UILabel!
    @IBOutlet weak var monthlyPriceLbl: UILabel!
    @IBOutlet weak var desc_lbl: UILabel!
    
    
    let signup = PassthroughSubject<SignupCredentials, Never>()
    var sc: SignupCredentials!
    var mData: AllProductsResponse!
    var selectedProduct: [Product]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        let nib = UINib(nibName: AnnualPricingView.NIB_NAME, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        container.frame = bounds
        addSubview(container)
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            desc_lbl.text = "For Your Area"
        }
        setupButtons()
    }
    
    func configure(data: AllProductsResponse){
        resetView()
        mData = data
        sc = SignupCredentials()
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            let product1 = data.products.filter{$0.title == "Digital ID 3000"}
            if let price = product1.first?.price{
                leftPriceView.isHidden = false
                annualPriceLbl.text = "$" + price
            }
            else{
                leftPriceView.isHidden = true
            }
            
            let product11 = data.products.filter{$0.title == "Digital ID"}
            if let price = product11.first?.price{
                leftPriceView.isHidden = false
                annualPriceLbl.text = "$" + price
            }
            else{
                leftPriceView.isHidden = true
            }
            
            let product2 = data.products.filter{$0.title == "Digital ID 1000"}
            if let price = product2.first?.price{
                middlePriceView.isHidden = false
                quartlyPriceLbl.text = "$" + price
            }
            else{
                middlePriceView.isHidden = true
            }
            
            let product3 = data.products.filter{$0.title == "Digital ID 2000"}
            if let price = product3.first?.price{
                rightPriceView.isHidden = false
                monthlyPriceLbl.text = "$" + price
            }
            else{
                rightPriceView.isHidden = true
            }
        }
        else{
            let product1 = data.products.filter{$0.title == "Digital ID (a)"}
            if let price = product1.first?.price{
                leftPriceView.isHidden = false
                annualPriceLbl.text = "$" + price
            }
            else{
                leftPriceView.isHidden = true
            }
            
            let product2 = data.products.filter{$0.title == "Digital ID (q)"}
            if let price = product2.first?.price{
                middlePriceView.isHidden = false
                quartlyPriceLbl.text = "$" + price
            }
            else{
                middlePriceView.isHidden = true
            }
            
            let product3 = data.products.filter{$0.title == "Digital ID (m)"}
            if let price = product3.first?.price{
                rightPriceView.isHidden = false
                monthlyPriceLbl.text = "$" + price
            }
            else{
                rightPriceView.isHidden = true
            }
        }
    }
    
    func resetView(){
        annualPriceLbl.text = ""
        monthlyPriceLbl.text = ""
        quartlyPriceLbl.text = ""
        leftBgImg.image = UIImage(named: "price_deselect_bg")
        middleBgImg.image = UIImage(named: "price_deselect_bg")
        rightBgImg.image = UIImage(named: "price_deselect_bg")
        setBtnDisable()
    }
    
    func setupButtons(){
        signUpBtn.layer.cornerRadius = 13
        setBtnDisable()
        
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.clickLeftPrice))
        self.leftPriceView.addGestureRecognizer(gesture1)
        
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.clickMiddlePrice))
        self.middlePriceView.addGestureRecognizer(gesture2)
        
        
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(self.clickRightPrice))
        self.rightPriceView.addGestureRecognizer(gesture3)
    }
    
    @objc func clickLeftPrice(sender : UITapGestureRecognizer) {
        setBtnEnable()
        leftBgImg.image = UIImage(named: "price_select_bg")
        middleBgImg.image = UIImage(named: "price_deselect_bg")
        rightBgImg.image = UIImage(named: "price_deselect_bg")
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            selectedProduct = mData.products.filter{$0.title == "Digital ID 3000"}
            if selectedProduct.count == 0{
                selectedProduct = mData.products.filter{$0.title == "Digital ID"}
            }
        }
        else{
            selectedProduct = mData.products.filter{$0.title == "Digital ID (a)"}
        }
        sc.billing_period = "year"
        sc.billing_interval = 1
    }
    
    @objc func clickMiddlePrice(sender : UITapGestureRecognizer) {
        setBtnEnable()
        leftBgImg.image = UIImage(named: "price_deselect_bg")
        middleBgImg.image = UIImage(named: "price_select_bg")
        rightBgImg.image = UIImage(named: "price_deselect_bg")
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            selectedProduct = mData.products.filter{$0.title == "Digital ID 1000"}
        }
        else{
            selectedProduct = mData.products.filter{$0.title == "Digital ID (q)"}
        }
        sc.billing_period = "year"
        sc.billing_interval = 4
    }
    
    @objc func clickRightPrice(sender : UITapGestureRecognizer) {
        setBtnEnable()
        leftBgImg.image = UIImage(named: "price_deselect_bg")
        middleBgImg.image = UIImage(named: "price_deselect_bg")
        rightBgImg.image = UIImage(named: "price_select_bg")
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            selectedProduct = mData.products.filter{$0.title == "Digital ID 2000"}
        }
        else{
            selectedProduct = mData.products.filter{$0.title == "Digital ID (m)"}
        }
        sc.billing_period = "month"
        sc.billing_interval = 1
    }
    
    @IBAction func clickSignUpBtn(_ sender: Any) {
        if let sProduct = selectedProduct{
            selectProduct(product: sProduct)
        }
        signup.send(sc)
    }
    
    func selectProduct(product: [Product]){
        if let price = product.first?.price{
            CharityListVC.productTitle = product.first?.title
            let orderItem = OrderItem()
            orderItem.id = product.first?.id ?? -1
            orderItem.orderType = 1
            orderItem.price = Double(price)
            orderItem.title = "1 x " + (product.first?.title ?? "")

            let item = Constant.OrderItemList.filter{$0.id == orderItem.id}
            guard item.count == 0 else {
                
                if let title = item.first?.title{
                    if let count = item.first?.itemCount{
                        item.first?.itemCount = count + 1
                        item.first?.title = title.replacingCharacters(in: ...title.startIndex, with: String(count + 1))
                        
                        item.first?.price! = Double(orderItem.price ?? 0) * Double(count + 1)
                    }
                    
                }
                return
            }
            
            Constant.OrderItemList.append(orderItem)
        }
    }
    
    func setBtnEnable(){
        signUpBtn.isEnabled = true
        signUpBtn.alpha = 1
    }
    
    func setBtnDisable(){
        signUpBtn.isEnabled = false
        signUpBtn.alpha = 0.5
    }
    
}
