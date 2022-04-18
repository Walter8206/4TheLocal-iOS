//
//  OrderListVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 21/8/21.
//

import UIKit
import SVProgressHUD
import Combine

class OrderListVC: UIViewController {

    
    @IBOutlet weak var topNav: TopNavigation!
    @IBOutlet weak var tableView: UITableView!
    
    static let identifire = "OrderListVC"
    var subscriptions = Set<AnyCancellable>()
    
    var itemCount = 0
    var orderList: [Order]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavView()
        initView()
        getOrderList()
    }

}

extension OrderListVC{
    func initView(){
        self.tableView.register(OrderListCell.nib(), forCellReuseIdentifier: OrderListCell.identifire)
    }
    
    func setupNavView(){
        topNav.titleLbl.text = "Order list"
        topNav.rightBtn.isHidden = true
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.navigationController?.popViewController(animated: true)
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
    
    func getOrderList(){
        SVProgressHUD().show()
        if let cusId = MyUserDefaults.shared.getString(key: MyUserDefaults.cusIdKey){
            
            HomeServices.orderListApi(cusId: cusId)
                .receive(on: DispatchQueue.main)
                .sink { response in
                    debugPrint(response)
                    SVProgressHUD.dismiss()
                } receiveValue: { value in
                    debugPrint(value)
                    SVProgressHUD.dismiss()
                    self.itemCount = value.orders.count
                    self.orderList = value.orders
                    self.tableView.reloadData()
                    
                }.store(in: &subscriptions)
        }
        
    }
    
    func openDetailPage(indexPath: IndexPath){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: OrderDetailVC.identifire) as? OrderDetailVC
        vc?.order = self.orderList[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}


extension OrderListVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderListCell.identifire)! as! OrderListCell
        if let order = self.orderList?[indexPath.row]{
            cell.configure(item: order)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetailPage(indexPath: indexPath)
    }
}
