//
//  AccTopNav.swift
//  4TheLocal
//
//  Created by Mahamudul on 26/7/21.
//

import UIKit
import Combine

class AccTopNav: UIView {

    private static let NIB_NAME = "AccTopNav"
    
    @IBOutlet private var view: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    let menuBtnPressed = PassthroughSubject<String?, Never>()
    let leftBtnPressed = PassthroughSubject<String?, Never>()
    let rightBtnPressed = PassthroughSubject<String?, Never>()
    
    override func awakeFromNib() {
        initWithNib()
    }
    
    @IBAction func menuBtnTapped(_ sender: Any) {
        menuBtnPressed.send(nil)
    }
    
    @IBAction func rightBtnTapped(_ sender: Any) {
        rightBtnPressed.send(nil)
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(AccTopNav.NIB_NAME, owner: self, options: nil)
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
}

