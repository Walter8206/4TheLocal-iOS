//
//  OrderDetailVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 21/8/21.
//

import UIKit
import SVProgressHUD
import Combine

class OrderDetailVC: UIViewController {

    @IBOutlet weak var topNav: TopNavigation!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderId_lbl: UILabel!
    
    static let identifire = "OrderDetailVC"
    var subscriptions = Set<AnyCancellable>()
    
    var itemCount = 10
    var order: Order!
    var itemList = [LineItem2]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavView()
        initView()
    }
}

extension OrderDetailVC{
    func initView(){
        if let order = order{
            orderId_lbl.text = "ORDER ID #" + String(order.id ?? 0)
        }
        if let items = order.lineItems{
            for item in items{
                itemList.append(item)
            }
        }
        self.tableView.register(OrderDetailCell.nib(), forCellReuseIdentifier: OrderDetailCell.identifire)
        tableView.reloadData()
    }
    
    func setupNavView(){
        topNav.titleLbl.text = "Order Details"
        topNav.rightBtn.isHidden = true
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.navigationController?.popViewController(animated: true)
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
}


extension OrderDetailVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailCell.identifire)! as! OrderDetailCell
        
        if indexPath.row == 0{
            cell.setHeader(title: "Order Detail", order: order)
        }
        else if indexPath.row == 1{
            cell.setOrderDate(order: order)
        }
        else if indexPath.row == 2{
            cell.setProductTitle(order: order)
        }
        else if indexPath.row == 3{
            cell.setSubtotal(order: order)
        }
        else if indexPath.row == 4{
            cell.setDiscount(order: order)
        }
        else if indexPath.row == 5{
            cell.setTotal(order: order)
        }

        else if indexPath.row == 6{
            cell.setHeader(title: "Billing Address", order: order)
        }
        else if indexPath.row == 7{
            cell.setBillingName(order: order)
        }

        else if indexPath.row == 8{
            cell.setBillingPhone(order: order)
        }

        else if indexPath.row == 9{
            cell.setBillingEmail(order: order)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height = 50
        if indexPath.row == 7{
            height = 70
        }
        
        else if indexPath.row == 2{
            height = 50 * itemList.count
        }
        
        else if indexPath.row == 8{
            height = 70
        }
        
        else if indexPath.row == 9{
            height = 70
        }
        
        return CGFloat(height)
    }
    
}
