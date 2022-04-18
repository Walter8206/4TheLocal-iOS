//
//  AccountVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 26/7/21.
//

import UIKit
import Combine
import SVProgressHUD

class AccountVC: UIViewController {
    
    static let identifire = "AccountVC"
    
    @IBOutlet weak var topNav: AccTopNav!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName_lbl: UILabel!
    @IBOutlet weak var currentDate_lbl: UILabel!
    @IBOutlet weak var currentTime_lbl: UILabel!
    @IBOutlet weak var profile_img: UIImageView!
    @IBOutlet weak var status_lbl: UILabel!
    @IBOutlet weak var status_view: DesignableView!
    @IBOutlet weak var app_img: UIImageView!
    
    var subscribtionId = 0
    
    var subscriptions: Set<AnyCancellable> = []
    var items = Constant.accItems
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard MyUserDefaults.shared.getString(key: MyUserDefaults.cusIdKey) != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.openAuthPage()
            }
            return
        }
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let cusId = MyUserDefaults.shared.getString(key: MyUserDefaults.cusIdKey){
            getUserInfo(cusId: cusId)
        }
    }
    
    
    @IBAction func accSettingsTapped(_ sender: Any) {
        openAccEdit()
    }
    
    @IBAction func profileEditTapped(_ sender: Any) {
        imagePick()
    }
    
    
}


extension AccountVC{
    
    func initView(){
        profileImg.layer.cornerRadius = 47
        self.tableView.register(AccViewCell.nib(), forCellReuseIdentifier: AccViewCell.identifire)
        
        topNav.menuBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.sideMenuController?.revealMenu()

            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        if let image  = ImagePickerManager.getSavedImage(named: "fileName.png"){
            profile_img.image = image
        }
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            app_img.image = UIImage(named: "scl_app_img")
        }
        else{
            app_img.image = UIImage(named: "app_img")
        }
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            items = Constant.sclAccItems
        }
    }
    
    func showLogoutAlert(){
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            MyUserDefaults.shared.clearAll()
            self.openAuthPage()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openAuthPage(){
        let mySceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        mySceneDelegate.openAuthPage()
    }
    
    func openOrderListPage(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: OrderListVC.identifire) as? OrderListVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func openAddressPage(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: AddressVC.identifire) as? AddressVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func openAccEdit(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: AccEditVC.identifire) as? AccEditVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func openCharityPage(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: CharityVC.identifire) as? CharityVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func openBusinessSignupPage(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: BusinessSignupVC.identifire) as? BusinessSignupVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func setupView(info: UserInfoResponse){
        userName_lbl.text = (info.firstName ?? "").uppercased() + " " + (info.lastName ?? "").uppercased()
        currentDate_lbl.text = "CURRENT DATE: " + MyCalendar.getCurrentDate()
        currentTime_lbl.text = "CURRENT TIME: " + MyCalendar.getCurrentTime()
        
        //debugPrint(info)
        let subs = info.metaData.filter{$0.key == "_wcs_subscription_ids_cache"}
        if let una = subs.first?.value{
            switch una {
            case .unionArray(let ve):
                switch ve.first {
                case .integerValue(let id):
                    subscribtionId = id
                    debugPrint("subscribtionId: \(id)")
                    SVProgressHUD().show()
                    getUserSubscription(sId: String(id))
                    break
                default:
                    break
                }
                
                break
            default:
                break
            }
        } 
    }
}

extension AccountVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        guard MyUserDefaults.shared.getString(key: MyUserDefaults.cusIdKey) != nil else {
            return 0
        }
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            return Constant.sclAccItems.count
        }
        else{
            return Constant.accItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AccViewCell.identifire)! as! AccViewCell
        
        guard MyUserDefaults.shared.getString(key: MyUserDefaults.cusIdKey) != nil else {
            return cell
        }
        
        cell.configure(name: items[indexPath.row])
        
        if items[indexPath.row] == items.last{
            cell.setLblColor(color: UIColor.red)
            cell.hideArrow()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if items[indexPath.row] == items.last{
            showLogoutAlert()
        }
        else if indexPath.row == 0{
            openOrderListPage()
        }
        else if indexPath.row == 1{
            openAddressPage()
        }
        else if items[indexPath.row] == "Charity"{
            openCharityPage()
        }
        else if items[indexPath.row] == "Business Setup"{
            //openBusinessSignupPage()
            self.openOnBrowser(link: Constant.shared.businessSignupLink)
        }
        else if items[indexPath.row] == "School Setup"{
            //openBusinessSignupPage()
            self.openOnBrowser(link: Constant.shared.schoolSignupLink)
        }
    }
    
    
    func getUserInfo(cusId: String){
        SVProgressHUD().show()
        AuthServices.getUserInfo(customerId: cusId)
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
            } receiveValue: { [self] value in
                MyUserDefaults.shared.saveUserInfo(note: value)
                setupView(info: value)
                SVProgressHUD.dismiss()
            }.store(in: &subscriptions)
    }
    
    
    func getUserSubscription(sId: String){
        
        AuthServices.getUserSubscription(sId: sId)
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
                SVProgressHUD.dismiss()
            } receiveValue: { [self] value in
                status_lbl.text = value.subscription.status?.uppercased()
                if value.subscription.status == "active"{
                    status_lbl.textColor = UIColor.green
                    status_view.layer.borderColor = UIColor.green.cgColor
                }
                else{
                    status_lbl.textColor = UIColor.red
                    status_view.layer.borderColor = UIColor.red.cgColor
                }
                debugPrint(value)
                SVProgressHUD.dismiss()
            }.store(in: &subscriptions)
    }
    
    func imagePick() {
        ImagePickerManager().pickImage(self){ [self] image in
            let isSaved = ImagePickerManager.saveImage(image: image)
            if isSaved{
                profile_img.image = ImagePickerManager.getSavedImage(named: "fileName.png")
            }
        }
    }
}
