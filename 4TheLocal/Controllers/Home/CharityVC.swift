//
//  CharityVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 25/7/21.
//

import UIKit
import Combine
import SVProgressHUD

class CharityVC: UIViewController {
    
    static let identifire = "CharityVC"
    var pageCount = 1
    var subscriptions: Set<AnyCancellable> = []

    @IBOutlet weak var topNav: TopNavigation!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var search_tf: UITextField!
    
    var charityList = [CharityResponseElement]()
    var tempList: [CharityResponseElement]!
    var cityList = [String]()
    var charityTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        requestCahrityApi(page: 1)
    }
}

extension CharityVC{
    
    func initView(){
        topNav.titleLbl.text = "Charity"
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.navigationController?.popViewController(animated: true)
            })
            .sink { _ in }
            .store(in: &subscriptions)

        self.tableView.register(CharityCell2.nib(), forCellReuseIdentifier: CharityCell2.identifire)
        
        search_tf.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        self.charityTypes.append(Constant.filterCharityTitle)
        self.cityList.append(Constant.filterCityTitle)
    }
    
    
    @IBAction func filterTapped(_ sender: Any) {
        showFilter()
    }
    
    @IBAction func sortTapped(_ sender: Any) {
        showSort()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let txt = textField.text?.lowercased() ?? ""

        self.charityList = self.charityList.filter{($0.title.rendered?.lowercased().starts(with:txt ))!}
        
        if textField.text?.count == 0{
            self.charityList = self.tempList
        }
        
        tableView.reloadData()
    }
    
    func openDetailPage(data: CharityResponseElement){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: DetailVC.identifire) as? DetailVC
        vc?.cData = data
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension CharityVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.charityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CharityCell2.identifire)! as! CharityCell2
        
        cell.configure(item: self.charityList[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetailPage(data: self.charityList[indexPath.row])
    }
}


extension CharityVC{
    
    func requestCahrityApi(page: Int){
        pageCount += 1
        SVProgressHUD().show()
        HomeServices.charityListApi(page: page)
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                SVProgressHUD.dismiss()
                
                //if let elements = value{
                    for element in value{
                        self.charityList.append(element)
                        self.loadFilters(element: element)
                    }
                //}
                
                let count = self.pageCount
                
                if let pageNo = MyUserDefaults.shared.getInt(key: MyUserDefaults.totalPages){
                    
                    if count <= pageNo{
                        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                            self.requestCahrityApi(page: count)
                        })
                    }
                    else{
                        self.tempList = self.charityList
                        self.tableView.reloadData()
                    }
                }
                
            }.store(in: &subscriptions)
    }
    
    
    func loadFilters(element: CharityResponseElement){
        if let city = element.acf.city ,!self.cityList.contains(city){
            self.cityList.append(city)
        }
        
        if let cType = element.acf.charityType{
            for type in cType{
                if let bt = type, !self.charityTypes.contains(bt){
                    self.charityTypes.append(bt)
                }
            }
        }
    }
    
    
    func showFilter(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: FilterVC.identifire) as? FilterVC
        vc?.cityList = self.cityList
        vc?.businessTypes = self.charityTypes
        vc?.typesTxt = Constant.filterCharityTitle
        vc?.applySelect
            .handleEvents(receiveOutput: { [self] filterData in
                if filterData?.business == nil && filterData?.city == nil{
                    sortNew()
                }
                else if let data = filterData{
                    sorByCity(filterData: data)
                }
                else{
                    sortNew()
                }
            })
            .sink { _ in }
            .store(in: &subscriptions)
        self.present(vc!, animated: true, completion: nil)
    }
    
    func showSort(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: SortVC.identifire) as? SortVC
        vc?.itemSelect
            .handleEvents(receiveOutput: { [self] newItem in
                if let type = newItem{
                    if type == 1{sortNew()}
                    else if type == 2{sortAsc()}
                    else{sortDesc()}
                }
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        self.present(vc!, animated: true, completion: nil)
    }
    
    func sortNew(){
        charityList = tempList
        tableView.reloadData()
    }
    
    func sortAsc(){
        self.charityList = self.charityList.sorted { (lhs: CharityResponseElement, rhs: CharityResponseElement) -> Bool in
            return lhs.title.rendered ?? "" < rhs.title.rendered ?? ""
        }
        self.tableView.reloadData()
    }
    
    func sortDesc(){
        self.charityList = self.charityList.sorted { (lhs: CharityResponseElement, rhs: CharityResponseElement) -> Bool in
            return lhs.title.rendered ?? "" > rhs.title.rendered ?? ""
        }
        self.tableView.reloadData()
    }
    
    func sorByCity(filterData: FilterDate){
        self.charityList = tempList
        
        if let city = filterData.city{
            self.charityList = self.charityList.filter{$0.acf.city == city}
        }
        if let bsns = filterData.business{
            self.charityList = self.charityList.filter{($0.acf.charityType?.contains(bsns))!}
        }
        self.tableView.reloadData()
    }
}
