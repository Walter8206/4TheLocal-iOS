//
//  CharityListVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 19/7/21.
//

import UIKit
import Combine
import SVProgressHUD

class CharityListVC: UIViewController {
    
    static let identifire = "CharityListVC"
    
    @IBOutlet weak var topNav: TopNavigation!
    @IBOutlet weak var tableView: UITableView!
    
    var charityList: CharityResponse? = nil
    var sc: SignupCredentials!
    var subscriptions = Set<AnyCancellable>()
    var couponList: CouponListResponse!
    static var productTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavView()
        initView()
        getCouponList()
    }
}

extension CharityListVC{
    
    func initView(){
        topNav.rightBtn.isHidden = true
        topNav.titleLbl.text = "Annually"
        self.tableView.register(CharityCell.nib(), forCellReuseIdentifier: CharityCell.identifire)
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
    
    
    func getCouponList(){
        SVProgressHUD().show()
        AuthServices.getCouponList()
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
            } receiveValue: { value in
                debugPrint(value)
                self.couponList = value
                SVProgressHUD.dismiss()
                self.requestCharityApi()
            }.store(in: &subscriptions)
    }
    
    func requestCharityApi(){
        SVProgressHUD().show()
        AuthServices.charitieListApi()
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
            } receiveValue: { value in
                
                SVProgressHUD.dismiss()
                self.charityList = value
                self.tableView.reloadData()
                
            }.store(in: &subscriptions)
    }
}


extension CharityListVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.charityList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CharityCell.identifire)! as! CharityCell
        if let charity = self.charityList?[indexPath.row]{
            cell.configure(item: charity)
        }
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let mCoupon = self.charityList?[indexPath.row]{
            selectCoupon(coupon: mCoupon)
        }
        
        //sc?.charityTitle = self.charityList?[indexPath.row].slug ?? ""
        openBillingPage()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension CharityListVC{
    
    func selectCoupon(coupon: CharityResponseElement){
        
        let products = couponList.filter{$0.productName == CharityListVC.productTitle}.first
        var code = ""
        if let couponsList = products?.charityCoupon{
            if let coupon = couponsList.filter({$0?.charitySlug == coupon.slug}).first{
                code = coupon?.couponCode ?? ""
            }

            
        }
        
        let orderItem = OrderItem()
        orderItem.id = 0
        orderItem.title = code
        orderItem.price = 0.0
        orderItem.orderType = 2
        
        let item = Constant.OrderItemList.filter{$0.title == orderItem.title}
        guard item.count == 0 else {
            return
        }
        
        Constant.OrderItemList.append(orderItem)
    }
    
    func openBillingPage(){
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: BillingDetailVC.identifire) as? BillingDetailVC
        vc?.sc = sc
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
