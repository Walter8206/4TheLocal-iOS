//
//  GiftPricingView.swift
//  4TheLocal
//
//  Created by Mahamudul on 18/7/21.
//

import Foundation
import UIKit
import Combine
import SVProgressHUD

class GiftPricingView: UIView {
    private static let NIB_NAME = "GiftPricingView"
    
    @IBOutlet var container: UIView!
    @IBOutlet weak var learnMorebtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    
    var sc: SignupCredentials!
    let giftSignup = PassthroughSubject<SignupCredentials, Never>()
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
        let nib = UINib(nibName: GiftPricingView.NIB_NAME, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        container.frame = bounds
        addSubview(container)
        
        setUpButtons()
    }
    
    func configure(data: AllProductsResponse){
        sc = SignupCredentials()
        mData = data
        resetView()
        
        let product1 = data.products.filter{$0.title == "Membership with Coupon"}
        if let price = product1.first?.price{
            priceLbl.text = "$" + price
        }
        
        let product2 = data.products.filter{$0.title == "Annual Membership Gift Certificate"}
        if let price = product2.first?.price{
            priceLbl.text = "$" + price
        }
        
    }
    
    func resetView(){
        priceLbl.text = ""
    }
    
    func setUpButtons(){
        learnMorebtn.layer.cornerRadius = 8
        signupBtn.layer.cornerRadius = 13
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        SVProgressHUD().show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            
            let title1 = "Membership with Coupon"
            let title2 = "Annual Membership Gift Certificate"
            var productList: [Product]
            
            productList = mData.products.filter{$0.title == title1}
            
            if productList.count == 0{
                productList = mData.products.filter{$0.title == title2}
            }
            
            selectProduct(product: productList)
            sc.billing_period = "year"
            sc.billing_interval = 1
            giftSignup.send(sc)
            SVProgressHUD.dismiss()
        }
        
    }
    
}

extension GiftPricingView{
    
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
