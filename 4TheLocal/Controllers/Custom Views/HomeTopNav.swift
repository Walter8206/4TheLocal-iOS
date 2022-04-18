//
//  HomeTopNav.swift
//  4TheLocal
//
//  Created by Mahamudul on 24/7/21.
//

import UIKit
import Combine

class HomeTopNav: UIView {

    private static let NIB_NAME = "HomeTopNav"
    
    @IBOutlet private var view: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var toggleBtnView: UIView!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var menuBtnWidthCons: NSLayoutConstraint!
    
    let menuBtnPressed = PassthroughSubject<String?, Never>()
    let leftBtnPressed = PassthroughSubject<String?, Never>()
    let rightBtnPressed = PassthroughSubject<String?, Never>()
    
    override func awakeFromNib() {
        initWithNib()
        toggleBtnView.isHidden = true
        setLeftBtn()
    }
    
    @IBAction func menuBtnTapped(_ sender: Any) {
        menuBtnPressed.send(nil)
    }
    
    @IBAction func leftBtnTapped(_ sender: Any) {
        setLeftBtn()
        leftBtnPressed.send(nil)
    }
    
    @IBAction func rightBtnTapped(_ sender: Any) {
        setRightBtn()
        rightBtnPressed.send(nil)
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(HomeTopNav.NIB_NAME, owner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        setupLayout()
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        )
    }
    
    func setLeftBtn(){
        leftBtn.layer.cornerRadius = 6
        leftBtn.addShadow()
        rightBtn.removeShadow()
        leftBtn.backgroundColor = UIColor().hexColor(hex: "#FFE200")
        rightBtn.backgroundColor = UIColor.clear
    }
    
    func setRightBtn(){
        rightBtn.layer.cornerRadius = 6
        rightBtn.addShadow()
        leftBtn.removeShadow()
        rightBtn.backgroundColor = UIColor().hexColor(hex: "#FFE200")
        leftBtn.backgroundColor = UIColor.clear
    }

}
