//
//  LocationVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 25/7/21.
//

import UIKit
import MapKit
import Combine
import SVProgressHUD

class LocationVC: UIViewController {
    
    static let identifire = "LocationVC"
    
    @IBOutlet weak var topNav: HomeTopNav!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search_tf: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var subscriptions: Set<AnyCancellable> = []
    var businessList = [BusinessResponseElement]()
    var tempList:[BusinessResponseElement]!
    var pageCount = 1
    var cityList = [String]()
    var businessTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        mapView.delegate = self

        
        MyUserDefaults.shared.saveInt(key: MyUserDefaults.sortTypeKey, value: 1)
        MyUserDefaults.shared.saveString(key: MyUserDefaults.businessFilterKey, value: nil)
        MyUserDefaults.shared.saveString(key: MyUserDefaults.cityFilterKey, value: nil)
        
        requestLocationApi(page: 1)
        NotificationCenter.default.addObserver(self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification, // UIApplication.didBecomeActiveNotification for swift 4.2+
            object: nil)
    }
    
    @objc func applicationDidBecomeActive() {
        self.displayMapPoints()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        showFilter()
    }
    
    @IBAction func sortTapped(_ sender: Any) {
        showSort()
    }
    
}

extension LocationVC{
    
    func initView(){
        topNav.toggleBtnView.isHidden = true
        topNav.titleLbl.isHidden = true
        topNav.toggleBtnView.isHidden = false
        //topNav.titleLbl.text = "Locations"
        topNav.leftBtn.setTitle("List View", for: .normal)
        topNav.rightBtn.setTitle("Map View", for: .normal)
        
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.tableView.isHidden = false
                self.mapView.isHidden = true
                //self.searchView.isHidden = false
            })
            .sink{ _ in }
            .store(in: &subscriptions)
        
        topNav.rightBtnPressed
            .handleEvents(receiveOutput: { [self] newItem in
                self.tableView.isHidden = true
                self.mapView.isHidden = false
                //self.searchView.isHidden = true
            })
            .sink{ _ in }
            .store(in: &subscriptions)
        
        self.tableView.register(LocationCell.nib(), forCellReuseIdentifier: LocationCell.identifire)
        topNav.menuBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.sideMenuController?.revealMenu()
                
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        
        search_tf.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        self.businessTypes.append(Constant.filterBusinessTitle)
        self.cityList.append(Constant.filterCityTitle)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let txt = textField.text?.lowercased() ?? ""
        
        self.businessList = self.businessList.filter{($0.title?.rendered?.lowercased().starts(with:txt ))!}
        
        if textField.text?.count == 0{
            self.businessList = self.tempList
        }
        
        tableView.reloadData()
        self.displayMapPoints()
    }
    
    func requestLocationApi(page: Int){
        pageCount += 1
        SVProgressHUD().show()
        HomeServices.businessListApi(page: page)
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                SVProgressHUD.dismiss()
                
                if let elements = value{
                    for element in elements{
                        self.businessList.append(element)
                        self.loadFilters(element: element)
                    }
                }
                
                let count = self.pageCount
                
                if let pageNo = MyUserDefaults.shared.getInt(key: MyUserDefaults.totalPages){
                    
                    if count <= pageNo{
                        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                            self.requestLocationApi(page: count)
                        })
                    }
                    else{
                        self.tempList = self.businessList
                        self.tableView.reloadData()
                        self.displayMapPoints()
                        
                    }
                }
                
            }.store(in: &subscriptions)
    }
    
    
    func loadFilters(element: BusinessResponseElement){
        if let city = element.acf?.city, !self.cityList.contains(city){
            self.cityList.append(city)
        }
        
        if let bTypes = element.acf?.businessType{
            for type in bTypes{
                if let bt = type, !self.businessTypes.contains(bt){
                    self.businessTypes.append(bt)
                }
            }
        }
    }
    
    func openDetailPage(data: BusinessResponseElement){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: DetailVC.identifire) as? DetailVC
        vc?.data = data
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension LocationVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.businessList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifire)! as! LocationCell
        
        cell.configure(item: self.businessList[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetailPage(data: self.businessList[indexPath.row])
    }
    
}


extension LocationVC{
    
    func showFilter(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: FilterVC.identifire) as? FilterVC
        vc?.cityList = self.cityList
        vc?.businessTypes = self.businessTypes
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
        businessList = tempList
        tableView.reloadData()
        self.displayMapPoints()
    }
    
    func sortAsc(){
        self.businessList = self.businessList.sorted { (lhs: BusinessResponseElement, rhs: BusinessResponseElement) -> Bool in
            return lhs.title?.rendered ?? "" < rhs.title?.rendered ?? ""
        }
        self.tableView.reloadData()
    }
    
    func sortDesc(){
        self.businessList = self.businessList.sorted { (lhs: BusinessResponseElement, rhs: BusinessResponseElement) -> Bool in
            return lhs.title?.rendered ?? "" > rhs.title?.rendered ?? ""
        }
        self.tableView.reloadData()
        self.displayMapPoints()
    }
    
    func sorByCity(filterData: FilterDate){
        self.businessList = tempList
        
        if let city = filterData.city{
            self.businessList = self.businessList.filter{$0.acf?.city == city}
        }
        if let bsns = filterData.business{
            self.businessList = self.businessList.filter{($0.acf?.businessType?.contains(bsns))!}
        }
        self.tableView.reloadData()
        self.displayMapPoints()
    }
    
}


extension LocationVC: MKMapViewDelegate{
    
    func displayMapPoints(){
        SVProgressHUD().show()
        
        self.mapView.cameraZoomRange = MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: 100000)
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        for location in self.businessList{
            
            let lat = location.acf?.mapLocation?.lat
            let lang = location.acf?.mapLocation?.lng
            
            if let lati = lat{
                if let langi = lang{
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = location.title?.rendered?.htmlToString
                    annotation.subtitle = location.acf?.mapLocation?.address
                    
                    let loc = CLLocationCoordinate2D(latitude: lati , longitude: langi )
                    
                    annotation.coordinate = loc
                                        // display annotation
                    self.mapView.showAnnotations([annotation], animated: true) // show pin
                    self.mapView.selectAnnotation(annotation, animated: true)
                    
//                    annotation.coordinate = loc
//                    mapView.addAnnotation(annotation)
//
//                    let viewRegion = MKCoordinateRegion(center: loc, latitudinalMeters: 500, longitudinalMeters: 500)
//                    mapView.setRegion(mapView.regionThatFits(viewRegion), animated: true)
                }
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            SVProgressHUD.dismiss()
            self.mapView.cameraZoomRange = MKMapView.CameraZoomRange(
                minCenterCoordinateDistance: 0)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                        
        let pinIdentifier = "point"
        let  annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
        annotationView.image = UIImage(named: "point")
        annotationView.canShowCallout = true
            return annotationView
        }
}
