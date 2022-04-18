//
//  DetailVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 23/8/21.
//

import UIKit
import Combine

class DetailVC: UIViewController {
    static let identifire = "DetailVC"
    
    
    @IBOutlet weak var topNav: TopNavigation!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var discount_lbl: UILabel!
    @IBOutlet weak var description_lbl: UILabel!
    @IBOutlet weak var type_lbl: UILabel!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var phone_lbl: UILabel!
    @IBOutlet weak var website_lbl: UILabel!
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var instaBtn: UIButton!
    
    
    var subscriptions = Set<AnyCancellable>()
    var data: BusinessResponseElement!
    var cData: CharityResponseElement!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavView()
        initView()
    }
    
    @IBAction func fbTapped(_ sender: Any) {
        if let data = data{
            if let link = data.acf?.facebook{
                openOnBrowser(link: link)
            }
        }
        
    }
    @IBAction func instaTapped(_ sender: Any) {
        if let data = data{
            if let link = data.acf?.instagram{
                openOnBrowser(link: link)
            }
        }
    }
    
}

extension DetailVC{
    func initView(){

        if let mData = data{
            
            type_lbl.isHidden = true
            
            if let url = mData.acf?.image?.url{
                HomeServices.loadImage(imageView: image, urlStr: url)
            }
            
            discount_lbl.text = mData.acf?.discount
            description_lbl.text = mData.acf?.acfDescription
            
            if let types = mData.acf?.businessType{
                type_lbl.text = types.first as? String
            }
            
            var address = (mData.acf?.address1 ?? "")
            address.append(", " + (mData.acf?.city ?? ""))
            
            address_lbl.text = address
                
            phone_lbl.text = mData.acf?.phone
            website_lbl.text = mData.acf?.website
            
            website_lbl.underline()
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
            website_lbl.isUserInteractionEnabled = true
            website_lbl.addGestureRecognizer(tap)
            
            let phoneTap = UITapGestureRecognizer(target: self, action: #selector(tapPhoneCallFunction))
            phone_lbl.isUserInteractionEnabled = true
            phone_lbl.addGestureRecognizer(phoneTap)
        }
        
        if let mData = cData{
            
            fbBtn.isHidden = true
            instaBtn.isHidden = true
            
            if let url = mData.acf.image.url{
                HomeServices.loadImage(imageView: image, urlStr: url)
            }
            
            //discount_lbl.text = mData.acf.acfDescription
            description_lbl.text = mData.acf.acfDescription
            
            if let types = mData.acf.charityType{
                type_lbl.text = types.first as? String
            }
            
            var address = (mData.acf.address1 ?? "")
            address.append(", " + (mData.acf.city ?? ""))
            
            address_lbl.text = address
            phone_lbl.text = mData.acf.phone
            website_lbl.text = mData.acf.website
            
            website_lbl.underline()
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
            website_lbl.isUserInteractionEnabled = true
            website_lbl.addGestureRecognizer(tap)
            
            let phoneTap = UITapGestureRecognizer(target: self, action: #selector(tapPhoneCallFunction))
            phone_lbl.isUserInteractionEnabled = true
            phone_lbl.addGestureRecognizer(phoneTap)
        }
    }
    
    @objc
        func tapFunction(sender:UITapGestureRecognizer) {
            if let data = data{
                if let link = data.acf?.website{
                    openOnBrowser(link: link)
                }
            }
            
            if let data = cData{
                if let link = data.acf.website{
                    openOnBrowser(link: link)
                }
            }
        }
    
    func setupNavView(){
        topNav.titleLbl.text = "Details"
        topNav.rightBtn.isHidden = true
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.navigationController?.popViewController(animated: true)
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
    
    @objc func tapPhoneCallFunction(sender:UITapGestureRecognizer) {
        if let phoneCallURL = URL(string: "tel://\(phone_lbl.text ?? "")") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }
}
