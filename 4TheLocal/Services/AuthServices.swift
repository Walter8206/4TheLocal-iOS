//
//  AuthServices.swift
//  4TheLocal
//
//  Created by Mahamudul on 29/7/21.
//

import Foundation
import Combine
import UIKit

class AuthServices{

    static let shared = AuthServices()
    //api endpoints
    private static let token = "/wp-json/jwt-auth/v1/token"
    private static let schoolSignup = "/wp-content/api/subscription.php"
    private static let userInfo = "/wp-json/wc/v3/customers/"
    private static let subscription = "/wc-api/v3/subscriptions/"
    private static let allProducts = "/wc-api/v3/products"
    static let charitiesList = "/wp-json/wp/v2/charities"
    private let createCustomers = "/wp-json/wc/v3/customers"
    private let order = "/wp-json/wc/v3/orders"
    private static let applyCoupon = "/wp-json/wc/v3/coupons"
    
    let stripeBaseUrl = "https://api.stripe.com/v1/"
    let stripePaymentMethod = "payment_methods"
    let stripeCreateCustomer = "customers"
    let stripePaymentIntent = "payment_intents"
    let stripeConfirmPaymentIntent = "confirm"
    static let couponList = "/wp-content/api/charity-coupon-api.php"
    static let forgotpass = "/wp-json/wp/v2/users/lostpassword"
    
    
    static let cache = Cache<Int, CharityResponse>()
    static let productCache = Cache<Int, AllProductsResponse>()
    
    //MARK Login Api
    static func loginApi(vc: UIViewController, _ email: String, _ pass: String) -> AnyPublisher<LoginResponse, ApiError> {
        
        let url = URL(string:Constant.shared.getBaseUrl() + token)!
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        
        let urlComponents = NSURLComponents(string: url.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "username", value: email),
            URLQueryItem(name: "password", value: pass)
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        // 1
        return session.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                
                do{
                    let response = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                    
                    if (response.code?.count ?? 0) > 0{
                        DispatchQueue.main.async {
                            if let msg = response.message{
                                vc.showAlert(msg: msg)
                            }
                        }
                    }
                }
                catch{
                    
                }
                
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK Login Api
    static func schoolSignUpApi(vc: UIViewController, sc: SignupCredentials) -> AnyPublisher<SchoolSignUpResponse, ApiError> {
        
        let url = URL(string:Constant.shared.getBaseUrl() + schoolSignup)!
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        
        let urlComponents = NSURLComponents(string: url.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "email", value: sc.email),
            URLQueryItem(name: "first_name", value: sc.first_name),
            URLQueryItem(name: "last_name", value: sc.last_name),
            URLQueryItem(name: "username", value: sc.email),
            URLQueryItem(name: "password", value: sc.password),
            URLQueryItem(name: "billing_first_name", value: sc.first_name),
            URLQueryItem(name: "billing_last_name", value: sc.last_name),
            URLQueryItem(name: "billing_company", value: sc.company),
            URLQueryItem(name: "billing_address_1", value: sc.address),
            URLQueryItem(name: "billing_address_2", value: ""),
            URLQueryItem(name: "billing_city", value: sc.city),
            URLQueryItem(name: "billing_state", value: sc.state),
            URLQueryItem(name: "billing_postcode", value: sc.zip),
            URLQueryItem(name: "billing_country", value: sc.country),
            URLQueryItem(name: "billing_email", value: sc.email),
            URLQueryItem(name: "billing_phone", value: sc.phone),
            URLQueryItem(name: "payment_method", value: sc.payment_method_id),
            URLQueryItem(name: "default_payment_method", value: sc.payment_method_id),
            URLQueryItem(name: "state", value: sc.boosterState),
            URLQueryItem(name: "county", value: sc.boosterCounty),
            URLQueryItem(name: "school", value: sc.boosterSchool),
            URLQueryItem(name: "booster", value: "\(sc.boosterList)"),
            URLQueryItem(name: "students", value: "\(sc.boosterStudentList)")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        // 1
        return session.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                
                do{
                    let response = try JSONDecoder().decode(SchoolSignUpErrorResponse.self, from: response.data)
                    
                    if (response.code != nil){
                        DispatchQueue.main.async {
                            if let msg = response.message{
                                vc.showAlert(msg: msg)
                            }
                        }
                    }
                }
                catch{
                    
                }
                
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: SchoolSignUpResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Get User Info
    static func getUserInfo(customerId: String) -> AnyPublisher<UserInfoResponse, ApiError>{
        
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + userInfo + customerId)!
        urlComponent.queryItems = [
            URLQueryItem(name: "consumer_key", value: Constant.shared.consumerKey),
            URLQueryItem(name: "consumer_secret", value: Constant.shared.consumerSecret)
        ]
    
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: (urlComponent.url)!)
        // 1
        return session.dataTaskPublisher(for: urlRequest)
            // 2
            .tryMap { response in
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                
                // 5
                return response.data
            }
            // 6
            .decode(type: UserInfoResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Get User Subscription
    static func getUserSubscription(sId: String) -> AnyPublisher<SubscribtionResponse, ApiError>{
        
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + subscription + sId)!
        urlComponent.queryItems = [
            URLQueryItem(name: "consumer_key", value: Constant.shared.consumerKey),
            URLQueryItem(name: "consumer_secret", value: Constant.shared.consumerSecret)
        ]
    
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: (urlComponent.url)!)
        // 1
        return session.dataTaskPublisher(for: urlRequest)
            // 2
            .tryMap { response in
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                
                // 5
                return response.data
            }
            // 6
            .decode(type: SubscribtionResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Get Coupon Info
    static func getCouponList() -> AnyPublisher<CouponListResponse, ApiError>{
        
        let urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + couponList)!
    
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: (urlComponent.url)!)
        // 1
        return session.dataTaskPublisher(for: urlRequest)
            // 2
            .tryMap { response in
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                
                // 5
                return response.data
            }
            // 6
            .decode(type: CouponListResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    //MARK: Get prices
    static func getAllProducts() -> AnyPublisher<AllProductsResponse, ApiError>{
        
//        if let cached = productCache[102] {
//            return Just<AllProductsResponse>(cached)
//                .setFailureType(to: ApiError.self)
//                .eraseToAnyPublisher()
//        }
        
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + allProducts)!
        urlComponent.queryItems = [
            URLQueryItem(name: "consumer_key", value: Constant.shared.consumerKey),
            URLQueryItem(name: "consumer_secret", value: Constant.shared.consumerSecret)
        ]
    
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: (urlComponent.url)!)
        // 1
        return session.dataTaskPublisher(for: urlRequest)
            // 2
            .tryMap { response in
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                
                do{
                    let response = try JSONDecoder().decode(AllProductsResponse.self, from: response.data)
                    
//                    if response.products.count > 0{
//                        self.productCache[102] = response
//                    }
                }
                
                // 5
                return response.data
            }
            // 6
            .decode(type: AllProductsResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Apply Coupon code
    static func applyCouponCode(code: String) -> AnyPublisher<ApplyCoupon, ApiError>{
        
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + applyCoupon)!
        urlComponent.queryItems = [
            URLQueryItem(name: "consumer_key", value: Constant.shared.consumerKey),
            URLQueryItem(name: "consumer_secret", value: Constant.shared.consumerSecret),
            URLQueryItem(name: "code", value: code)
        ]
    
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: (urlComponent.url)!)
        // 1
        return session.dataTaskPublisher(for: urlRequest)
            // 2
            .tryMap { response in
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: ApplyCoupon.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK charitie list Api
    static func charitieListApi() -> AnyPublisher<CharityResponse, ApiError> {
        
        if let cached = cache[101] {
            return Just<CharityResponse>(cached)
                .setFailureType(to: ApiError.self)
                .eraseToAnyPublisher()
        }
        
        let url = URL(string:Constant.shared.getBaseUrl() + charitiesList)!
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
       
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        // 1
        return session.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                
                do{
                    let response = try JSONDecoder().decode(CharityResponse.self, from: response.data)
                    
                    if response.isEmpty == false{
                        self.cache[101] = response
                    }
                }
                
                // 5
                return response.data
            }
            // 6
            .decode(type: CharityResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Forgot Password
    static func forgotPass(vc: UIViewController, email: String) -> AnyPublisher<ForgotPassResponse, ApiError>{
        
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + forgotpass)!
        urlComponent.queryItems = [
            URLQueryItem(name: "consumer_key", value: Constant.shared.consumerKey),
            URLQueryItem(name: "consumer_secret", value: Constant.shared.consumerSecret)
        ]
        
         let jsonParams: [String: String] = ["user_login": email]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonParams)
        let bearer = "Bearer " + (MyUserDefaults.shared.getString(key: MyUserDefaults.tokenKey) ?? "")
    
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        // 1
        return session.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                
                do{
                    let response = try JSONDecoder().decode(ForgotPassResponse.self, from: response.data)
                    
                    DispatchQueue.main.async {
                        if let msg = response.message{
                            vc.showAlert(msg: msg)
                        }
                    }
                }
                catch{
                    
                }
                
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: ForgotPassResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Create a Customer
    func createCustomer(vc: UIViewController, sc: SignupCredentials) -> AnyPublisher<CreateCustomerResponse, ApiError>{
        
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + createCustomers)!
        urlComponent.queryItems = [
            URLQueryItem(name: "consumer_key", value: Constant.shared.consumerKey),
            URLQueryItem(name: "consumer_secret", value: Constant.shared.consumerSecret)
        ]
        
         let jsonParams: [String: Any] =
            ["email": sc.email,
             "first_name": sc.first_name,
             "last_name": sc.last_name,
             "username": sc.email,
             "password": sc.password,
             "billing": ["first_name": sc.first_name,
                         "last_name": sc.last_name,
                         "company": sc.company,
                         "address_1": sc.address,
                         "address_2": "",
                         "city": sc.city,
                         "state": sc.state,
                         "postcode": sc.zip,
                         "country": sc.country,
                         "email": sc.email,
                         "phone": sc.phone]]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonParams)
        let bearer = "Bearer " + (MyUserDefaults.shared.getString(key: MyUserDefaults.tokenKey) ?? "")
    
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        // 1
        return session.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                
                do{
                    let response = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                    
                    if response.code == "registration-error-email-exists"{
                        DispatchQueue.main.async {
                            vc.showAlert(msg: "User already exist")
                        }
                    }
                }
                catch{
                    
                }
                
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 201
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: CreateCustomerResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Create a Customer
    func updateCustomer(vc: UIViewController, sc: SignupCredentials) -> AnyPublisher<UserUpdateResponse, ApiError>{
        
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + createCustomers + "/" + String(sc.customer_id) )!
        urlComponent.queryItems = [
            URLQueryItem(name: "consumer_key", value: Constant.shared.consumerKey),
            URLQueryItem(name: "consumer_secret", value: Constant.shared.consumerSecret)
        ]
        
         let jsonParams: [String: Any] =
            ["email": sc.email,
             "first_name": sc.first_name,
             "last_name": sc.last_name,
             "password": sc.password,
             "billing": ["first_name": sc.first_name,
                         "last_name": sc.last_name,
                         "company": sc.company,
                         "address_1": sc.address,
                         "address_2": "",
                         "city": sc.city,
                         "state": sc.state,
                         "postcode": sc.zip,
                         "country": sc.country,
                         "email": sc.email,
                         "phone": sc.phone]]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonParams)
        let bearer = "Bearer " + (MyUserDefaults.shared.getString(key: MyUserDefaults.tokenKey) ?? "")
    
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        // 1
        return session.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: UserUpdateResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Create an Order
    func createOrder(vc: UIViewController, sc: SignupCredentials) -> AnyPublisher<OrderResponse, ApiError>{
        
        var lineItemsList = [[String: String]]()
        
        let products = Constant.OrderItemList.filter{$0.orderType == 1}
        for item in products{
            let quantity = String(item.title?.first ?? "1")
            let id = String(item.id ?? 0)
            let price: String = String(item.price ?? 0)
            
            let product = ["product_id": id,
                           "quantity": quantity,
                           "tax_class": "",
                           "subtotal": price,
                           "subtotal_tax": "0.00",
                           "total": price,
                           "total_tax": "0.00",
                           //"taxes": [""],
                           "sku": "",
                           "price": price]
            
            lineItemsList.append(product)
        }
        
        
        var couponCode = [String:String]()
        var couponList = [[String:String]]()
        let coupons = Constant.OrderItemList.filter{$0.orderType == 2}
        for item in coupons{
            let code = String(item.title ?? "")
            let price: String = String(item.price ?? 0)
            
            let coupon = ["code": code,
                          "discount": price,
                          "discount_tax": "0"]
            
            couponList.append(coupon)
        }
        
        if sc.couponCode.count > 0 && sc.couponDiscount.count > 0{
            couponCode = ["code": sc.couponCode,
                          "discount": sc.couponDiscount,
                          "discount_tax": "0"]
            couponList.append(couponCode)
        }
                
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + order)!
        urlComponent.queryItems = [
            URLQueryItem(name: "consumer_key", value: Constant.shared.consumerKey),
            URLQueryItem(name: "consumer_secret", value: Constant.shared.consumerSecret)
        ]
        
        
         let jsonParams: [String: Any] =
            ["payment_method": "stripe",
             "payment_method_title": "Credit Card",
             "transaction_id": sc.transection_id,
             "set_paid": true,
             "currency": "USD",
             "prices_include_tax": false,
             "discount_total": "00.00",
             "discount_tax": "0.00",
             "shipping_total": "0.00",
             "shipping_tax": "0.00",
             "cart_tax": "0.00",
             "total": sc.productPrice,
             "total_tax": "0.00",
             "customer_id": sc.customer_id,
             "customer_note": "test note",
             "billing": ["first_name": sc.billing?.firstName,
                         "last_name": sc.billing?.lastName,
                         "company": sc.billing?.company,
                         "country": sc.billing?.country,
                         "address_1": sc.billing?.address1,
                         "address_2": sc.billing?.address2,
                         "city": sc.billing?.city,
                         "state": sc.billing?.state,
                         "postcode": sc.billing?.postcode,
                         "email": sc.billing?.email,
                         "phone": sc.billing?.phone],
             
             "line_items": lineItemsList,
             
             "coupon_lines": couponList
            ]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonParams)
        let bearer = "Bearer " + (MyUserDefaults.shared.getString(key: MyUserDefaults.tokenKey) ?? "")
    
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        // 1
        return session.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                
                do{
                    let response = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                    
                    DispatchQueue.main.async {
                        if let msg = response.message{
                            vc.showAlert(msg: msg)
                        }
                    }
                }
                catch{
                    
                }
                
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 201
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: OrderResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Create Subscription
    func createSubscription(vc: UIViewController, sc: SignupCredentials) -> AnyPublisher<CreateSubscribtionResponse, ApiError>{
        
        var lineItemsList = [[String: String]]()
        
        let products = Constant.OrderItemList.filter{$0.orderType == 1}
        for item in products{
            let quantity = String(item.title?.first ?? "1")
            let id = String(item.id ?? 0)
            let price: String = String(item.price ?? 0)
            
            let product = ["product_id": id,
                           "quantity": quantity,
                           "tax_class": "",
                           "subtotal": price,
                           "subtotal_tax": "0.00",
                           "total": price,
                           "total_tax": "0.00",
                           //"taxes": [""],
                           "sku": "",
                           "price": price]
            
            lineItemsList.append(product)
        }
        
        
        var couponCode = [String:String]()
        var couponList = [[String:String]]()
        let coupons = Constant.OrderItemList.filter{$0.orderType == 2}
        for item in coupons{
            let code = String(item.title ?? "")
            let price: String = String(item.price ?? 0)
            
            let coupon = ["code": code,
                          "discount": price,
                          "discount_tax": "0"]
            
            couponList.append(coupon)
        }
        
        if sc.couponCode.count > 0 && sc.couponDiscount.count > 0{
            couponCode = ["code": sc.couponCode,
                          "discount": sc.couponDiscount,
                          "discount_tax": "0"]
            couponList.append(couponCode)
        }
                
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + AuthServices.subscription)!
        urlComponent.queryItems = [
            URLQueryItem(name: "consumer_key", value: Constant.shared.consumerKey),
            URLQueryItem(name: "consumer_secret", value: Constant.shared.consumerSecret)
        ]
        
         let jsonParams: [String: Any] =
            ["subscription": [
                "order_id": sc.orderId,
                "status": "on-hold",
                "billing_period": sc.billing_period,
                "billing_interval": sc.billing_interval,
                "start_date": MyCalendar.getDateForApi(),
                "customer_note": sc.notes,
                "customer_id": sc.customer_id,
                
                "payment_details": [
                    "method_id": "stripe",
                    "method_title": "Stripe (Card)",
                    "post_meta": ["_stripe_customer_id": sc.stripe_customer_id]],
                
                "billing_address": ["first_name": sc.billing?.firstName,
                                    "last_name": sc.billing?.lastName,
                                    "company": sc.billing?.company,
                                    "country": sc.billing?.country,
                                    "address_1": sc.billing?.address1,
                                    "address_2": sc.billing?.address2,
                                    "city": sc.billing?.city,
                                    "state": sc.billing?.state,
                                    "postcode": sc.billing?.postcode,
                                    "email": sc.billing?.email,
                                    "phone": sc.billing?.phone],
            
                "line_items": lineItemsList,
                
                "coupon_lines": couponList
            ]
            ]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonParams)
        let bearer = "Bearer " + (MyUserDefaults.shared.getString(key: MyUserDefaults.tokenKey) ?? "")
    
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        // 1
        return session.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                
                do{
                    let response = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                    
                    DispatchQueue.main.async {
                        if let msg = response.message{
                            vc.showAlert(msg: msg)
                        }
                    }
                }
                catch{
                    
                }
                
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 201
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: CreateSubscribtionResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Create Subscription
    func createSchoolSubscription(vc: UIViewController, sc: SignupCredentials) -> AnyPublisher<SchoolSignUpResponse, ApiError>{
        
        var lineItemsList = [[String: String]]()
        
        let products = Constant.OrderItemList.filter{$0.orderType == 1}
        for item in products{
            let quantity = String(item.title?.first ?? "1")
            let id = String(item.id ?? 0)
            let price: String = String(item.price ?? 0)
            
            let product = ["product_id": id,
                           "quantity": quantity,
                           "tax_class": "",
                           "subtotal": price,
                           "subtotal_tax": "0.00",
                           "total": price,
                           "total_tax": "0.00",
                           //"taxes": [""],
                           "sku": "",
                           "price": price]
            
            lineItemsList.append(product)
        }
        
        
        var couponCode = [String:String]()
        var couponList = [[String:String]]()
        let coupons = Constant.OrderItemList.filter{$0.orderType == 2}
        for item in coupons{
            let code = String(item.title ?? "")
            let price: String = String(item.price ?? 0)
            
            let coupon = ["code": code,
                          "discount": price,
                          "discount_tax": "0"]
            
            couponList.append(coupon)
        }
        
        if sc.couponCode.count > 0 && sc.couponDiscount.count > 0{
            couponCode = ["code": sc.couponCode,
                          "discount": sc.couponDiscount,
                          "discount_tax": "0"]
            couponList.append(couponCode)
        }
        
        
        let fees = [ "id": "1143",
                     "name": "Processing Fee",
                     "tax_class": "0",
                     "tax_status": "taxable",
                     "amount": "1.5",
                     "total": "1.50",
                     "total_tax": "0.00",
                     "taxes": [],
                     "meta_data": []] as [String : Any]
        
        
                
        let urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + AuthServices.schoolSignup)!
        
        
        let productPrice = sc.productPrice * 100
        
        let jsonParams: [String: Any] =
            [
                "email": sc.email,
                "first_name": sc.first_name,
                "last_name": sc.last_name,
                "username": sc.email,
                "password": sc.password,
                "billing_first_name": sc.first_name,
                "billing_last_name": sc.last_name,
                "billing_company": sc.company,
                "billing_address_1": sc.address,
                "billing_address_2": sc.address,
                "billing_city": sc.city,
                "billing_state": sc.state,
                "billing_postcode": sc.zip,
                "billing_country": sc.country,
                "billing_email": sc.email,
                "billing_phone": sc.phone,
                "billing_period": sc.billing_period,
                "billing_interval": sc.billing_interval,
                "customer_note": sc.notes,
                "payment_method": sc.payment_method_id,
                "default_payment_method": sc.payment_method_id,
                "total_amount": productPrice,
                "state": sc.boosterState,
                "county": sc.boosterCounty,
                "school": sc.boosterSchool,
                "booster": [sc.boosterList],
                "students": [sc.boosterStudentList],
                "line_items": lineItemsList,
                "coupon_lines": couponList,
                "fee_lines": fees
            ]


        let jsonData = try? JSONSerialization.data(withJSONObject: jsonParams)
        let bearer = "Bearer " + (MyUserDefaults.shared.getString(key: MyUserDefaults.tokenKey) ?? "")
    
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        // 1
        return session.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                
                do{
                    let response = try JSONDecoder().decode(SchoolSignUpErrorResponse.self, from: response.data)
                    
                    DispatchQueue.main.async {
                        if let msg = response.message{
                            vc.showAlert(msg: msg)
                        }
                    }
                }
                catch{
                    
                }
                
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: SchoolSignUpResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Create a Payment Method
    func createPaymentMethod(vc: UIViewController, sc: SignupCredentials) -> AnyPublisher<StripeCreatePaymentMethodResponse, ApiError>{
        
        let url = URL(string:stripeBaseUrl + stripePaymentMethod)!
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        
        let urlComponents = NSURLComponents(string: url.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "type", value: "card"),
            URLQueryItem(name: "card[number]", value: sc.cardNumber),
            URLQueryItem(name: "card[exp_month]", value: sc.card_exp_month),
            URLQueryItem(name: "card[exp_year]", value: sc.card_exp_year),
            URLQueryItem(name: "card[cvc]", value: sc.card_cvc)
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Constant.stripeBearer, forHTTPHeaderField: "Authorization")
        // 1
        return session.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                
                
                do{
                    let response = try JSONDecoder().decode(PaymentErroreResponse.self, from: response.data)
                    
                    if response.error.message.count > 0{
                        DispatchQueue.main.async {
                            vc.showAlert(msg: response.error.message)
                        }
                    }
                }
                catch{
                    //throw ApiError.statusCode
                }
                
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: StripeCreatePaymentMethodResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Stripe create a customer
    func stripeCreateCustomer(vc: UIViewController, sc: SignupCredentials) -> AnyPublisher<StripeCreateCustomerResponse, ApiError>{
        
        let url = URL(string:stripeBaseUrl + stripeCreateCustomer)!
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        
        let urlComponents = NSURLComponents(string: url.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "payment_method", value: sc.payment_method_id),
            URLQueryItem(name: "name", value: sc.first_name + sc.last_name),
            URLQueryItem(name: "phone", value: sc.phone),
            URLQueryItem(name: "email", value: sc.email),
            URLQueryItem(name: "invoice_settings[default_payment_method]", value: sc.payment_method_id)
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Constant.stripeBearer, forHTTPHeaderField: "Authorization")
        // 1
        return session.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                
                do{
                    let response = try JSONDecoder().decode(PaymentErroreResponse.self, from: response.data)
                    
                    if response.error.message.count > 0{
                        DispatchQueue.main.async {
                            vc.showAlert(msg: response.error.message)
                        }
                    }
                }
                catch{
                    //throw ApiError.statusCode
                }
                
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: StripeCreateCustomerResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Stripe payment intent
    func stripePaymentIntent(vc: UIViewController, sc: SignupCredentials) -> AnyPublisher<StripePaymentIntentResponse, ApiError>{
        
        let url = URL(string:stripeBaseUrl + stripePaymentIntent)!
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        
        let productPrice = sc.productPrice * 100
        
        let urlComponents = NSURLComponents(string: url.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "amount", value: String(Int(productPrice))),
            URLQueryItem(name: "currency", value: sc.currency),
            URLQueryItem(name: "payment_method_types[]", value: sc.payment_method_types),
            URLQueryItem(name: "customer", value: sc.stripe_customer_id)
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Constant.stripeBearer, forHTTPHeaderField: "Authorization")
        // 1
        return session.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                
                do{
                    let response = try JSONDecoder().decode(PaymentErroreResponse.self, from: response.data)
                    
                    if response.error.message.count > 0{
                        DispatchQueue.main.async {
                            vc.showAlert(msg: response.error.message)
                        }
                    }
                }
                catch{
                    //throw ApiError.statusCode
                }
                
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: StripePaymentIntentResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    //MARK: Stripe confirm payment intent
    func stripeConfirmPaymentIntent(vc: UIViewController, sc: SignupCredentials) -> AnyPublisher<StripeConfirmPaymentIntentResponse, ApiError>{
        
        let url = URL(string:stripeBaseUrl + stripePaymentIntent + "/" + sc.payment_intent_id + "/" + stripeConfirmPaymentIntent)!
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        
        let urlComponents = NSURLComponents(string: url.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "payment_method", value: sc.payment_method_id)
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Constant.stripeBearer, forHTTPHeaderField: "Authorization")
        // 1
        return session.dataTaskPublisher(for: request)
            // 2
            .tryMap { response in
                
                do{
                    let response = try JSONDecoder().decode(PaymentErroreResponse.self, from: response.data)
                    
                    if response.error.message.count > 0{
                        DispatchQueue.main.async {
                            vc.showAlert(msg: response.error.message)
                        }
                    }
                }
                catch{
                    //throw ApiError.statusCode
                }
                
                guard
                    // 3
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: StripeConfirmPaymentIntentResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Image upload
    func uploadImage(image: UIImage) {
        let url = URL(string: Constant.shared.uploadImageLink);
        let bearer = "Bearer " + (MyUserDefaults.shared.getString(key: MyUserDefaults.tokenKey) ?? "")
        
        let request = NSMutableURLRequest(url: url!);
        request.httpMethod = "POST"
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue(bearer, forHTTPHeaderField: "Authorization")

        let retreivedImage: UIImage? = image

        let imageData = retreivedImage!.jpegData(compressionQuality: 1)
        if (imageData == nil) {
            print("UIImageJPEGRepresentation return nil")
            return
        }

        let body = NSMutableData()
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format: "Content-Disposition: form-data; name=\"api_token\"\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        //body.append(NSString(format: (UserDefaults.standard.string(forKey: "api_token")! as NSString)).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format:"Content-Disposition: form-data; name=\"file\"; filename=\"testfromios.jpg\"\r\n").data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        body.append(imageData!)
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)

        request.httpBody = body as Data

        let task =  URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            if data != nil {
               // do what you want in success case
                do{
                    let aaa = response as! HTTPURLResponse
                    debugPrint(aaa.statusCode)
                    
                    
                    let response = try JSONDecoder().decode(ImageUploadResponse.self, from: data!)
                    debugPrint(response)
                }
                catch{
                    //throw ApiError.statusCode
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        })

        task.resume()
    }
}


