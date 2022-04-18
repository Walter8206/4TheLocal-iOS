//
//  TopNavigation.swift
//  4TheLocal
//
//  Created by Mahamudul on 4/7/21.
//

import UIKit
import Combine

class TopNavigation: UIView {

    private static let NIB_NAME = "TopNavigation"
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    
    let leftBtnPressed = PassthroughSubject<String?, Never>()
    let rightBtnPressed = PassthroughSubject<String?, Never>()
    
    override func awakeFromNib() {
        initWithNib()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        leftBtnPressed.send(nil)
    }
    
    @IBAction func rightBtnTapped(_ sender: Any) {
        rightBtnPressed.send(nil)
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(TopNavigation.NIB_NAME, owner: self, options: nil)
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
