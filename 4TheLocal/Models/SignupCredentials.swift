//
//  SignupCredentials.swift
//  4TheLocal
//
//  Created by Mahamudul on 13/8/21.
//

import Foundation

class SignupCredentials{
    
    var first_name = ""
    var last_name = ""
    var email = ""
    var username = ""
    var password = ""
    var company = ""
    var country = ""
    var address = ""
    var city = ""
    var state = ""
    var zip = ""
    var phone = ""
    var notes = ""
    
    var payment_method_id = ""
    var stripe_customer_id = ""
    var customer_id = 0
    var currency = "usd"
    var payment_method_types = "card"
    var payment_intent_id = ""
    var transection_id = ""
    var billing: Billing?
    
    var productTitle = ""
    var productId = -1
    var productPrice = 0.0
    
    var cardType = ""
    var cardNumber = "0"
    var card_exp_month = ""
    var card_exp_year = ""
    var card_cvc = ""
    
    var charityTitle = ""
    
    var couponCode = ""
    var couponDiscount = ""
    
    var orderId = 0
    var billing_period = "year"
    var billing_interval = 1
    
    var boosterState = ""
    var boosterCounty = ""
    var boosterSchool = ""
    var boosterList = [String]()
    var boosterStudentList = [String]()
}
