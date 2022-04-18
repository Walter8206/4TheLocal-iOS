//
//  SideMenuVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 10/8/21.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuVC: UIViewController {
    //@IBOutlet var headerImageView: UIImageView!
    @IBOutlet var sideMenuTableView: UITableView!
    //@IBOutlet var footerLabel: UILabel!

    var defaultHighlightedCell: Int = 0
    var delegate: SideMenuViewControllerDelegate?
    
    var menu: [SideMenuModel]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            menu = [
                SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "ANNUAL MEMBERSHIP"),
                SideMenuModel(icon: UIImage(systemName: "music.note")!, title: "GIFT a MEMBERSHIP"),
                //SideMenuModel(icon: UIImage(systemName: "film.fill")!, title: "PART-TIME RESIDENTS"),
                SideMenuModel(icon: UIImage(systemName: "book.fill")!, title: "Privacy policy"),
                SideMenuModel(icon: UIImage(systemName: "person.fill")!, title: "Support")
            ]
        }
        else{
            menu = [
                SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "ANNUAL MEMBERSHIP"),
                SideMenuModel(icon: UIImage(systemName: "music.note")!, title: "GIFT a MEMBERSHIP"),
                SideMenuModel(icon: UIImage(systemName: "film.fill")!, title: "PART-TIME RESIDENTS"),
                SideMenuModel(icon: UIImage(systemName: "book.fill")!, title: "Privacy policy"),
                SideMenuModel(icon: UIImage(systemName: "person.fill")!, title: "Support")
            ]
        }

        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self

        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }

        // Register TableView Cell
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)

        // Update TableView with the data
        self.sideMenuTableView.reloadData()
    }
    
    @IBAction func instagramTapped(_ sender: Any) {
        openOnBrowser(link: Constant.instagramLink)
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
        openOnBrowser(link: Constant.facebookLink)
    }
}

// MARK: - UITableViewDelegate

extension SideMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UITableViewDataSource

extension SideMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }

        cell.titleLabel.text = self.menu[indexPath.row].title

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // ...
        self.delegate?.selectedCell(indexPath.row)
        self.sideMenuController?.hideMenu()
        
        if menu[indexPath.row].title == "Privacy policy"{
            self.openOnBrowser(link: Constant.shared.privacyLink)
        }
        
        else if menu[indexPath.row].title == "Support"{
            self.openOnBrowser(link: Constant.shared.supportLink)
        }
        else{
            openPricingPage()
        }
    }
    
    func openPricingPage(){
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: PricingVC.identifire) as! PricingVC
        vc.isFromHomeAndSkip = true
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isNavigationBarHidden = true
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true, completion: nil)
    }
}
