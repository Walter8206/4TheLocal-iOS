//
//  AddressVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 21/8/21.
//

import UIKit
import SVProgressHUD
import Combine

class AddressVC: UIViewController {
    static let identifire = "AddressVC"
    
    @IBOutlet weak var topNav: TopNavigation!
    @IBOutlet weak var tableView: UITableView!
    
    var subscriptions = Set<AnyCancellable>()
    
    var itemCount = 0
    var userResponse: UserInfoResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavView()
        initView()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if let cusId = MyUserDefaults.shared.getString(key: MyUserDefaults.cusIdKey){
            getUserInfo(cusId: cusId)
        }
    }
}

extension AddressVC{
    func initView(){
        self.tableView.register(AddressCell.nib(), forCellReuseIdentifier: AddressCell.identifire)
    }
    
    func setupNavView(){
        topNav.titleLbl.text = "Addresses"
        topNav.rightBtn.isHidden = true
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.navigationController?.popViewController(animated: true)
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
    
    func openBillingPage(){
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: BillingDetailVC.identifire) as? BillingDetailVC
        vc?.isUpdateOnly = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getUserInfo(cusId: String){
        SVProgressHUD().show()
        AuthServices.getUserInfo(customerId: cusId)
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                MyUserDefaults.shared.saveUserInfo(note: value)
                SVProgressHUD.dismiss()
                self.userResponse = value
                self.itemCount = 1
                self.tableView.reloadData()
            }.store(in: &subscriptions)
    }

}


extension AddressVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressCell.identifire)! as! AddressCell
        
        cell.editPressed
            .handleEvents(receiveOutput: { newItem in
                self.openBillingPage()
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        if let user = self.userResponse{
            cell.config(user: user)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
