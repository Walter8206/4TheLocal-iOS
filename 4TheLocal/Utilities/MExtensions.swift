//
//  MExtentions.swift
//  4TheLocal
//
//  Created by Mahamudul on 28/6/21.
//

import UIKit
import SVProgressHUD

typealias ActionCompletion = (UIAlertAction) -> ()

class MExtensions: NSObject {
    

    
}


extension UIView{
    
    func roudCorners(radius: CGFloat){
        self.layer.cornerRadius = radius
    }
    
    func addShadow() {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 2.0
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: 1, height: 1)
            self.layer.masksToBounds = false
    }
    
    func removeShadow(){
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.masksToBounds = false
    }
}


extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: textString.count))
            self.attributedText = attributedString
        }
    }

}



extension UIColor {
    func hexColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension Bool{
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}


extension SVProgressHUD{
    func show(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundLayerColor(.clear)
        SVProgressHUD.show()
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIViewController{
    
    func showAlert(title: String = "", msg: String, btnTitle: String = "OK"){
        
        let message = msg.htmlToString
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: btnTitle, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openOnBrowser(link: String){
        guard let url = URL(string: link) else { return }
        UIApplication.shared.open(url)
    }

    
    func showSighupSuccessAlertWith(title: String, msg: String, handler: ActionCompletion? = nil) {
        let errorAlert = UIAlertController(title: title,
                                           message: msg,
                                           preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: handler)
        [okAction].forEach {
            errorAlert.addAction($0)
        }
        present(errorAlert, animated: true, completion: nil)
    }
}
