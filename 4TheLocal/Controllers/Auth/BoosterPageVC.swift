//
//  BoosterPageVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 8/9/21.
//

import UIKit
import Combine
import SVProgressHUD

class BoosterPageVC: UIViewController {
    static let identifire = "BoosterPageVC"
    
    @IBOutlet weak var topNav: TopNavigation!
    @IBOutlet weak var state_tf: UITextField!
    @IBOutlet weak var state_view: DesignableView!
    @IBOutlet weak var county_tf: UITextField!
    @IBOutlet weak var county_view: DesignableView!
    @IBOutlet weak var school_tf: UITextField!
    @IBOutlet weak var school_view: DesignableView!
    @IBOutlet weak var booster_lbl: UILabel!
    @IBOutlet weak var booster_tbl: UITableView!
    @IBOutlet weak var booster_tbl_height: NSLayoutConstraint!
    @IBOutlet weak var student_lbl: UILabel!
    @IBOutlet weak var student_tbl: UITableView!
    @IBOutlet weak var student_tbl_height: NSLayoutConstraint!
    @IBOutlet weak var continueBtn: UIButton!
    
    var subscriptions = Set<AnyCancellable>()
    var clickSubscriptions = Set<AnyCancellable>()
    var stateList: [StateResponseElement]!
    var schoolList: [SchoolsResponseElement]!
    var boosterList: [BoostersResponseElement]!
    var studentResponseList = [StudentsResponse]()
    var studentList = [Student]()
    var counties: CountyResponse!
    var stateCode: String!
    var sc = SignupCredentials()
    var boosterArray = [String]()
    var studentArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupNavView()
        requestStates()
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        openBillingPage(sc: sc)
        
    }
    
}


extension BoosterPageVC{
    
    func initView(){
        continueBtn.layer.cornerRadius = 13
        let stateGesture = UITapGestureRecognizer(target: self, action: #selector(stateSelect(sender:)))
        state_view.addGestureRecognizer(stateGesture)
        
        let countyGesture = UITapGestureRecognizer(target: self, action: #selector(countySelect(sender:)))
        county_view.addGestureRecognizer(countyGesture)
        
        let schoolGesture = UITapGestureRecognizer(target: self, action: #selector(schoolSelect(sender:)))
        school_view.addGestureRecognizer(schoolGesture)
        
        self.booster_tbl.register(BoostersCell.nib(), forCellReuseIdentifier: BoostersCell.identifire)
        self.student_tbl.register(BoostersCell.nib(), forCellReuseIdentifier: BoostersCell.identifire)
    }
    
    @objc func stateSelect(sender : UITapGestureRecognizer) {
        if let states = stateList{
            showStateList(list: states)
        }
    }
    
    @objc func countySelect(sender : UITapGestureRecognizer) {
        
        if let counties = counties{
            showCountyList(counties: counties)
        }
    }
    
    @objc func schoolSelect(sender : UITapGestureRecognizer) {
        
        if let schools = schoolList{
            showSchoolList(list: schools)
        }
    }
    
    func openBillingPage(sc: SignupCredentials){
        
//        state_tf.text = "New Yourk"
//        county_tf.text = "Queens"
//        school_tf.text = "Test School"
//        boosterArray.append("Booster 1")
//        boosterArray.append("Booster 2")
//        studentArray.append("Student 1")
//        studentArray.append("Student 2")
        
        sc.boosterState = state_tf.text ?? ""
        sc.boosterCounty = county_tf.text ?? ""
        sc.boosterSchool = school_tf.text ?? ""
        sc.boosterList = boosterArray
        sc.boosterStudentList = studentArray
        
        if checkValidation().count > 0{
            showAlert(msg: checkValidation())
            return
        }
        
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: BillingDetailVC.identifire) as? BillingDetailVC
        vc?.sc = sc
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func checkValidation()-> String{
        var msg = ""
        
        if sc.boosterState.count == 0{
            msg = "Please select State."
            return msg
        }
        else if sc.boosterCounty.count == 0{
            msg = "Please select County."
            return msg
        }
        else if sc.boosterSchool.count == 0{
            msg = "Please select School."
            return msg
        }
        else if sc.boosterList.count == 0{
            msg = "Please select Booster."
            return msg
        }
        else if sc.boosterStudentList.count == 0{
            msg = "Please select Student."
            return msg
        }
        
        return msg
    }
    
    func setupNavView(){
        topNav.view.backgroundColor = UIColor.white
        topNav.titleLbl.text = "Boosters Page"
        topNav.rightBtn.isHidden = true
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.navigationController?.popViewController(animated: true)
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
    
    
    func showStateList(list: [StateResponseElement]){
        
        guard list.count > 0 else {
            return
        }
        
        let refreshAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)

        for item in list{
            refreshAlert.addAction(UIAlertAction(title: item.stateName, style: .default, handler: { [self] (action: UIAlertAction!) in
                
                state_tf.text = item.stateName
                if let stCode = item.stateCode{
                    stateCode = stCode
                    requestCounties(stateCode: stCode)
                }
            }))
        }
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func showCountyList(counties: CountyResponse){
        
        guard counties.counties?.count ?? 0 > 0 else {
            return
        }
        
        let refreshAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)

        for item in counties.counties!{
            refreshAlert.addAction(UIAlertAction(title: item, style: .default, handler: { [self] (action: UIAlertAction!) in
                
                county_tf.text = item
                if let stCode = stateCode{
                    requestSchools(stateCode: stCode, county: item)
                    
                }
            }))
        }
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func showSchoolList(list: [SchoolsResponseElement]){
        
        guard list.count > 0 else {
            return
        }
        
        let refreshAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)

        for item in list{
            refreshAlert.addAction(UIAlertAction(title: item.schoolName, style: .default, handler: { [self] (action: UIAlertAction!) in
                
                school_tf.text = item.schoolName
                if stateCode != nil && item.countyName != nil && item.schoolName != nil{
                    requestBoosters(stateCode: stateCode, county: item.countyName!, school: item.schoolName!)
                }
            }))
        }
        present(refreshAlert, animated: true, completion: nil)
    }
    
}


//MARK:- All API CALLS HERE
extension BoosterPageVC{
    
    func requestStates(){
        SVProgressHUD().show()
        SchoolServices.getStates()
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
            } receiveValue: { [self] values in
                SVProgressHUD.dismiss()
                stateList = values
            }.store(in: &subscriptions)
    }
    
    func requestCounties(stateCode: String){
        SVProgressHUD().show()
        SchoolServices.getCounties(stateCode: stateCode)
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
                debugPrint(response)
            } receiveValue: { [self] values in
                debugPrint(values)
                SVProgressHUD.dismiss()
                counties = values
            }.store(in: &subscriptions)
    }
    
    func requestSchools(stateCode: String, county: String){
        SVProgressHUD().show()
        SchoolServices.getSchools(stateCode: stateCode, county: county)
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
                debugPrint(response)
            } receiveValue: { [self] values in
                debugPrint(values)
                SVProgressHUD.dismiss()
                schoolList = values
            }.store(in: &subscriptions)
    }
    
    func requestBoosters(stateCode: String, county: String, school: String){
        studentResponseList.removeAll()
        boosterArray.removeAll()
        studentArray.removeAll()
        arrangeStudents()
        student_tbl.reloadData()
        SVProgressHUD().show()
        SchoolServices.getBoosters(stateCode: stateCode, county: county, schoolName: school)
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
                debugPrint(response)
            } receiveValue: { [self] values in
                debugPrint(values)
                SVProgressHUD.dismiss()
                boosterList = values
                if boosterList != nil{
                    booster_tbl_height.constant = CGFloat(boosterList.count * 40)
                }
                booster_tbl.reloadData()
            }.store(in: &subscriptions)
    }
    
    
    func requestStudents(stateCode: String, county: String, school: String, booster: String){
        SVProgressHUD().show()
        SchoolServices.getStudents(stateCode: stateCode, county: county, schoolName: school, booster: booster)
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
                debugPrint(response)
            } receiveValue: { [self] values in
                debugPrint(values)
                SVProgressHUD.dismiss()
                studentResponseList.append(values)
                arrangeStudents()
            }.store(in: &subscriptions)
    }
    
    func arrangeStudents(){
        studentArray.removeAll()
        studentList.removeAll()
        for response in studentResponseList{
            if let students = response.first?.students{
                for std in students{
                    if std != nil{
                        studentList.append(std!)
                    }
                }

                if studentList.count > 0{
                    student_tbl_height.constant = CGFloat((studentList.count + 1) * 40)
                }
                
            }
        }
        student_tbl.reloadData()
        
    }
}


extension BoosterPageVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == booster_tbl{
            if boosterList != nil{
                clickSubscriptions.removeAll()
                return boosterList.count
            }
            return 0
        }
        else{
            if studentList.count > 0{
                return studentList.count
            }
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == booster_tbl{
            let cell = booster_tbl.dequeueReusableCell(withIdentifier: BoostersCell.identifire)! as! BoostersCell
            
            let item = boosterList[indexPath.row]
            cell.configure(item: item)
            cell.itemClick
                .handleEvents(receiveOutput: {[self] newItem in
                    
                    if newItem?.isSelect == false{
                        boosterArray.removeAll { name in
                            name == newItem?.name
                        }
                        studentResponseList.removeAll { ste in
                            ste.first?.booster == newItem?.name
                        }
                        arrangeStudents()
                    }
                    else if stateCode != nil && county_tf.text != nil && item.booster != nil && school_tf.text != nil{
                        boosterArray.append(item.booster!)
                        requestStudents(stateCode: stateCode, county: county_tf.text!, school: school_tf.text!, booster: item.booster!)
                    }
                    
                })
                .sink { _ in }
                .store(in: &clickSubscriptions)
            return cell
        }
        else{
            let cell = student_tbl.dequeueReusableCell(withIdentifier: BoostersCell.identifire)! as! BoostersCell
            
            let std = studentList[indexPath.row]
                cell.configureStudent(name: std)
                cell.itemClick
                    .handleEvents(receiveOutput: { [self] newItem in
                        if newItem?.isSelect == false{
                            studentArray.removeAll { name in
                                name == newItem?.name
                            }
                        }
                        else{
                            studentArray.append(newItem!.name)
                        }
                    })
                    .sink { _ in }
                    .store(in: &clickSubscriptions)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == booster_tbl{
            let cell = tableView.cellForRow(at: indexPath) as! BoostersCell
            cell.selectItem()
            tableView.deselectRow(at: indexPath, animated: false)
        }
        else{
            let cell = tableView.cellForRow(at: indexPath) as! BoostersCell
            cell.selectItem()
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
    }
}

