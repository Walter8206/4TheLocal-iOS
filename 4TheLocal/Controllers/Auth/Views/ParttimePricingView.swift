//
//  ParttimePricingView.swift
//  4TheLocal
//
//  Created by Mahamudul on 18/7/21.
//

import Foundation
import UIKit
import Combine

class ParttimePricingView: UIView {
    private static let NIB_NAME = "ParttimePricingView"
    
    @IBOutlet var container: UIView!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    
    var sc: SignupCredentials!
    let signup = PassthroughSubject<SignupCredentials, Never>()
    var mData: AllProductsResponse!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: ParttimePricingView.NIB_NAME, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        container.frame = bounds
        addSubview(container)
        
        setUpButtons()
    }
    
    func configure(data: AllProductsResponse){
        mData = data
        sc = SignupCredentials()
        resetView()
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            let product1 = data.products.filter{$0.title == "PT Resident Membership"}
            if let price = product1.first?.price{
                priceLbl.text = "$" + price
            }
        }
        else{
            let product1 = data.products.filter{$0.title == "PT Resident Digital ID"}
            if let price = product1.first?.price{
                priceLbl.text = "$" + price
            }
        }
        
        
        
    }
    
    func resetView(){
        priceLbl.text = ""
    }
    
    func setUpButtons(){
        signupBtn.layer.cornerRadius = 8
    }
    
    
    @IBAction func signupTapped(_ sender: Any) {
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            let product1 = mData.products.filter{$0.title == "PT Resident Membership"}
            selectProduct(product: product1)
        }
        else{
            let product1 = mData.products.filter{$0.title == "PT Resident Digital ID"}
            selectProduct(product: product1)
        }
        
        sc.billing_period = "year"
        sc.billing_interval = 1
        signup.send(sc)
    }
}


extension ParttimePricingView{
    
    func selectProduct(product: [Product]){
        if let price = product.first?.price{
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
}
