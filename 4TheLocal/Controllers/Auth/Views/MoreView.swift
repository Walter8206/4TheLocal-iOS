//
//  MoreView.swift
//  4TheLocal
//
//  Created by Mahamudul on 18/7/21.
//

import Foundation
import UIKit
import Combine

class MoreView: UIView {
    private static let NIB_NAME = "MoreView"
    
    @IBOutlet var container: UIView!
    @IBOutlet weak var learnMoreBtn: UIButton!
    
    let moreBtnPressed = PassthroughSubject<String, Never>()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: MoreView.NIB_NAME, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        container.frame = bounds
        addSubview(container)
        
        setUpButtons()
    }
    
    
    func setUpButtons(){
        learnMoreBtn.layer.cornerRadius = 13
    }
    
    @IBAction func morebtnTapped(_ sender: Any) {
        moreBtnPressed.send("")
    }
    
}
