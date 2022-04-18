//
//  PaymentDetailVC.swift
//  4TheLocal
//
//  Created by Mahamudul on 20/7/21.
//

import UIKit
import Combine
import SVProgressHUD
import CreditCardValidator

class PaymentDetailVC: UIViewController {
    
    static let identifire = "PaymentDetailVC"
    
    @IBOutlet weak var topNav: TopNavigation!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var purchaseBtn: UIButton!
    @IBOutlet weak var cardNum_tf: UITextField!
    @IBOutlet weak var monthYear_tf: UITextField!
    @IBOutlet weak var cvc_tf: UITextField!
    @IBOutlet weak var couponCode_tf: UITextField!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var agreeImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var valided_lbl: UILabel!
    
    
    var subscriptions = Set<AnyCancellable>()
    var signupCredentials: SignupCredentials!
    var isAgreed = false
    var orderCount = 0
    var orderItemList = [OrderItem]()
    var orderTryAgain = false
    var paymentTryAgain = false
    var isLogedinUser = false
    var lastCharCount = 0
    let localCreateMsg = "Thank you for your purchase & support! Please allow us to verify your billing address and activate your account. "
    let sclCreateMsg = "Thank you for your purchase & support!"

    override func viewDidLoad() {
        super.viewDidLoad()

        initview()
        setupNavView()
        setOrderList()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Constant.OrderItemList.removeAll { orderItem in
            orderItem.title == Constant.subtotal
        }
        
//        Constant.OrderItemList.removeAll { orderItem in
//            orderItem.title == Constant.total
//        }
    }
    
    @IBAction func purchaseTapped(_ sender: Any) {
        
        if signupCredentials.productPrice <= 0{
            showAlert(msg: "Payment cannot be processed with less than $1.00")
            return
        }
        
        guard checkValidation().count == 0 else {
            showAlert(msg: checkValidation())
            return
        }

        signupCredentials.cardNumber = cardNum_tf.text ?? ""
        signupCredentials.card_cvc = cvc_tf.text ?? ""

        if let date = monthYear_tf.text{
            signupCredentials.card_exp_month = String(date.split(separator: "/")[0])
            signupCredentials.card_exp_year  = String(date.split(separator: "/")[1])
        }

        if MyUserDefaults.shared.getString(key: MyUserDefaults.emailKey) != nil{
            updateCustomer()
        }
        else if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            createStripePaymentMeyhod()
        }
        else{
            if paymentTryAgain{
                createStripePaymentMeyhod()
            }
            else if orderTryAgain{
                createOrder()
            }
            else{
                createCustomer()
            }
        }
        
    }
    
    
    @IBAction func applyCouponTapped(_ sender: Any) {
        
        let code = orderItemList.filter{$0.title == couponCode_tf.text}
        guard code.count == 0 else {
            showAlert(msg: "Coupon code already applied!")
            return
        }
        
        applyCouponCode()
    }
    
    @IBAction func agreeBtnTapped(_ sender: Any) {
        isAgreed = !isAgreed
        
        if isAgreed == true{
            selectAgree()
        }
        else{
            deselectAgree()
        }
    }
    
    
    func openHomePage(){
        let mySceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        mySceneDelegate.openHomePage()
    }
}

extension PaymentDetailVC{
    func initview(){
        
        self.tableView?.register(OrderCell.nib(), forCellReuseIdentifier: OrderCell.identifire)
        
        applyBtn.layer.cornerRadius = 4
        purchaseBtn.layer.cornerRadius = 10
        
        if MyUserDefaults.shared.getString(key: MyUserDefaults.emailKey) != nil{
            isLogedinUser = true
        }

//        cardNum_tf.text = "4242424242424242"
//        monthYear_tf.text = "08/2028"
//        cvc_tf.text = "123"
        
        cardNum_tf.addTarget(self, action: #selector(self.numberFieldDidChange(_:)), for: .editingChanged)
        monthYear_tf.addTarget(self, action: #selector(self.dateFieldDidChange(_:)), for: .editingChanged)
        cvc_tf.addTarget(self, action: #selector(self.cvvFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func dateFieldDidChange(_ textField: UITextField) {
        
        if monthYear_tf.text!.count > 5{
            let result = String(monthYear_tf.text!.prefix(5))
            monthYear_tf.text = result
            return
        }
        
        var interval = 0.0
        
        if lastCharCount > monthYear_tf.text!.count{
            interval = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [self] in
            if monthYear_tf.text?.count == 2{
                monthYear_tf.text = (monthYear_tf.text ?? "") + "/"
            }
        }
        
        lastCharCount = monthYear_tf.text?.count ?? 0
    }
    
    
    @objc func cvvFieldDidChange(_ textField: UITextField) {
        
        if cvc_tf.text!.count > 3{
            let result = String(cvc_tf.text!.prefix(3))
            cvc_tf.text = result
            return
        }
    }
    
    @objc func numberFieldDidChange(_ textField: UITextField) {
        
        if CreditCardValidator(textField.text ?? "").isValid {
          // Card number is valid
            valided_lbl.isHidden = true
        } else {
          // Card number is invalid
            valided_lbl.isHidden = false
        }
    }
    
    func selectAgree(){
        //agreeImg.image = UIImage(named: "radio_select")
        purchaseBtn.alpha = 1
        purchaseBtn.isEnabled = true
    }
    
    func deselectAgree(){
        //agreeImg.image = UIImage(named: "radio_deselect")
        purchaseBtn.alpha = 0.5
        purchaseBtn.isEnabled = false
    }
    
    func setupNavView(){
        topNav.titleLbl.text = "Payment Details"
        topNav.leftBtnPressed
            .handleEvents(receiveOutput: { newItem in
                self.navigationController?.popViewController(animated: true)
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        topNav.rightBtn.isHidden = true
    }
    
    func checkValidation()-> String{
        
        guard let num = cardNum_tf.text, num.count > 0 else {
            return "Card number field is empty"
        }
        
        guard let mont = monthYear_tf.text, mont.count > 0 else {
            return "MM/YY field is empty"
        }
        
        guard let cvc = cvc_tf.text, cvc.count > 0 else {
            return "CVC field is empty"
        }
        
        return ""
    }
    
    func setOrderList(){
        
        var totalProductPrice = 0.0
        let productList = Constant.OrderItemList.filter{$0.orderType == 1}
        for product in productList{
            totalProductPrice += product.price ?? 0
            orderItemList.append(product)
        }
        
        let subT = OrderItem()
        subT.orderType = 3
        subT.title = Constant.subtotal
        subT.price = totalProductPrice
        
        orderItemList.append(subT)
        
        var totalCouponPrice = 0.0
        let couponList = Constant.OrderItemList.filter{$0.orderType == 2}
        for coupon in couponList{
            totalCouponPrice += coupon.price ?? 0
            orderItemList.append(coupon)
        }
        
        if totalCouponPrice > totalProductPrice{
            totalCouponPrice = totalProductPrice
        }
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            let processingFee = OrderItem()
            processingFee.orderType = 3
            processingFee.title = Constant.processingFee
            processingFee.price = Constant.processingFeeAmount
            totalProductPrice = totalProductPrice + Constant.processingFeeAmount
            orderItemList.append(processingFee)
        }
        
        
        let total = OrderItem()
        total.orderType = 3
        total.title = Constant.total
        total.price = (totalProductPrice - totalCouponPrice).rounded(toPlaces: 2)
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            if total.price! <= Constant.processingFeeAmount{
                total.price = Constant.processingFeeAmount
            }
        }
        
        self.signupCredentials.productPrice = total.price!
        orderItemList.append(total)
        
        orderCount = orderItemList.count
        
        tableHeight.constant = CGFloat(50 * orderCount)
        tableView.reloadData()
    }
}

extension PaymentDetailVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifire)! as! OrderCell
        cell.config(item: orderItemList[indexPath.row])
          
        cell.deletePressed
            .handleEvents(receiveOutput: { orderItem in
                
                let couponItems = Constant.OrderItemList.filter{$0.orderType == 2}
                if couponItems.first?.price == orderItem?.price{
                    self.signupCredentials.couponCode = ""
                    self.signupCredentials.couponDiscount = ""
                }
                
                let items = Constant.OrderItemList.filter{$0.orderType == 1}
                if items.count == 1 && Constant.OrderItemList.count == 1{
                    self.showAlert(msg: "Do not delete all items.")
                }
                else {
                    Constant.OrderItemList.removeAll { mOrderItem in
                        orderItem?.title == mOrderItem.title
                    }
                    self.orderItemList.removeAll()
                    self.setOrderList()
                }
            })
            .sink { _ in }
            .store(in: &subscriptions)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    
}


extension PaymentDetailVC{
    
    func requestSchoolSignupApi(sc: SignupCredentials){
        DispatchQueue.main.async {
            SVProgressHUD().show()
        }
        AuthServices.shared.createSchoolSubscription(vc: self, sc: sc)
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                debugPrint(value)
                SVProgressHUD.dismiss()
                
                if value.creatingSubscription != nil{
                    self.requestLoginApi(self.signupCredentials.email, self.signupCredentials.password)
                }
                
            }.store(in: &subscriptions)
    }
    
    func createCustomer(){
        SVProgressHUD().show()
        AuthServices.shared.createCustomer(vc: self, sc: signupCredentials)
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                debugPrint(value)
                self.signupCredentials.customer_id = value.id ?? -1
                if let billing = value.billing{
                    self.signupCredentials.billing = billing
                }
                SVProgressHUD.dismiss()
                self.createStripePaymentMeyhod()
            }.store(in: &subscriptions)
    }
    
    
    func updateCustomer(){
        SVProgressHUD().show()
        AuthServices.shared.updateCustomer(vc: self, sc: signupCredentials)
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                debugPrint(value)
                
                if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                
                self.signupCredentials.customer_id = value.id ?? -1
                if let billing = value.billing{
                    self.signupCredentials.billing = billing
                }
                SVProgressHUD.dismiss()
                self.createStripePaymentMeyhod()
            }.store(in: &subscriptions)
    }
    
    
    func applyCouponCode(){
        
        guard let code = couponCode_tf.text, code.count > 2 else {
            showAlert(msg: "Coupon field is empty.")
            return
        }
        
        for item in Constant.OrderItemList{
            if item.title?.lowercased() == code.lowercased(){
                self.showAlert(msg: "Coupon code already applied!")
                return
            }
        }
        
        SVProgressHUD().show()
        AuthServices.applyCouponCode(code: code)
            .receive(on: DispatchQueue.main)
            .sink { response in
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                debugPrint(value)
                
                self.signupCredentials.couponCode = value.first?.code ?? ""
                self.signupCredentials.couponDiscount = value.first?.amount ?? "0"
                
                let totalPrice = self.signupCredentials.productPrice
                
                if value.count == 0{
                    self.showAlert(msg: "Coupon '\(code)' does not exist!")
                    return
                }
                
                let cOrder = OrderItem()
                cOrder.id =  value.first?.id
                cOrder.orderType = 2
                if let code = value.first?.code{
                    cOrder.title =  code
                }
                
                if let price = value.first?.amount{
                                        
                    if Double(price)! > totalPrice{
                        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
                            cOrder.price =  totalPrice - Constant.processingFeeAmount
                        }
                        else{
                            cOrder.price =  totalPrice
                        }
                        
                    }
                    else{
                        cOrder.price =  Double(price)
                    }
                    
                }
                
                Constant.OrderItemList.append(cOrder)
                self.orderItemList.removeAll()
                self.setOrderList()
                
                SVProgressHUD.dismiss()
            }.store(in: &subscriptions)
    }
    
    func createStripePaymentMeyhod(){
        SVProgressHUD().show()
        AuthServices.shared.createPaymentMethod(vc: self, sc: signupCredentials)
            .receive(on: DispatchQueue.main)
            .sink { response in
                self.paymentTryAgain = true
                SVProgressHUD.dismiss()
                debugPrint(response)
            } receiveValue: { value in
                
                self.signupCredentials.payment_method_id = value.id ?? ""
                
                if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
                    self.requestSchoolSignupApi(sc: self.signupCredentials)
                    return
                }
                
                self.paymentTryAgain = false
                SVProgressHUD.dismiss()
                self.createStripeCustomer()
            }.store(in: &subscriptions)
    }
    
    func createStripeCustomer(){
        SVProgressHUD().show()
        AuthServices.shared.stripeCreateCustomer(vc: self, sc: self.signupCredentials)
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
            } receiveValue: { value in
                debugPrint(value)
                self.signupCredentials.stripe_customer_id = value.id ?? ""
                SVProgressHUD.dismiss()
                self.stripePaymentIntent()
            }.store(in: &subscriptions)
    }
    
    func stripePaymentIntent(){
        SVProgressHUD().show()
        AuthServices.shared.stripePaymentIntent(vc: self, sc: self.signupCredentials)
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                debugPrint(value)
                self.signupCredentials.payment_intent_id = value.id ?? ""
                SVProgressHUD.dismiss()
                self.stripePaymentIntentConfirm()
            }.store(in: &subscriptions)
    }
    
    
    func stripePaymentIntentConfirm(){
        SVProgressHUD().show()
        AuthServices.shared.stripeConfirmPaymentIntent(vc: self, sc: self.signupCredentials)
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                debugPrint(value)
                self.signupCredentials.transection_id = value.charges.data.first?.id ?? ""
                SVProgressHUD.dismiss()
                self.createOrder()
            }.store(in: &subscriptions)
    }
    
    
    func createOrder(){
        SVProgressHUD().show()
        AuthServices.shared.createOrder(vc:self, sc: self.signupCredentials)
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
                self.orderTryAgain = true
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                debugPrint(value)
                self.signupCredentials.orderId = value.id ?? 0
                SVProgressHUD.dismiss()
                self.createSubscription()
            }.store(in: &subscriptions)
    }
    
    
    func createSubscription(){
        SVProgressHUD().show()
        AuthServices.shared.createSubscription(vc:self, sc: self.signupCredentials)
            .receive(on: DispatchQueue.main)
            .sink { response in
                debugPrint(response)
                self.orderTryAgain = true
                SVProgressHUD.dismiss()
            } receiveValue: { value in
                debugPrint(value)
                self.orderTryAgain = false
                Constant.OrderItemList.removeAll()
                SVProgressHUD.dismiss()
                
                if self.isLogedinUser{
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    self.requestLoginApi(self.signupCredentials.email, self.signupCredentials.password)
                }
            }.store(in: &subscriptions)
    }
    
    
    func requestLoginApi(_ email: String, _ pass: String){
        
        
        let vc = self
        
        let handler: ActionCompletion = { [weak self] _ in
            SVProgressHUD().show()
            AuthServices.loginApi(vc: vc, email, pass)
                .receive(on: DispatchQueue.main)
                .sink { response in
                    
                    SVProgressHUD.dismiss()
                    
                } receiveValue: { value in
                    
                    SVProgressHUD.dismiss()
                    MyUserDefaults.shared.saveInt(key: MyUserDefaults.cusIdKey, value: value.id!)
                    MyUserDefaults.shared.saveString(key: MyUserDefaults.userTokenKey, value: value.token)
                    MyUserDefaults.shared.saveString(key: MyUserDefaults.emailKey, value: value.userEmail)
                    MyUserDefaults.shared.saveString(key: MyUserDefaults.nameKey, value: value.userDisplayName)
                    
                    vc.openHomePage()
                    
                }.store(in: &vc.subscriptions)
        }
        
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey){
            showSighupSuccessAlertWith(title: "", msg: sclCreateMsg, handler: handler)
        }
        else{
            showSighupSuccessAlertWith(title: "", msg: localCreateMsg, handler: handler)
        }
    }
}
