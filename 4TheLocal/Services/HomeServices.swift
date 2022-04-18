//
//  HomeServices.swift
//  4TheLocal
//
//  Created by Mahamudul on 30/7/21.
//

import Foundation
import Combine
import UIKit

class HomeServices{
    
    static let shared = HomeServices()
    
    static let cache = Cache<String, UIImage>()
    
    //api endpoints
    private static let businessList = "/wp-json/wp/v2/businesses"
    let businessSignUp = "/wp-json/wp/v2/businesses"
    static let orderList = "/wc-api/v3/customers/"
    
    //MARK business list Api
    static func businessListApi(page: Int) -> AnyPublisher<LocationResponse, ApiError> {
        
        let url = URL(string:Constant.shared.getBaseUrl() + businessList)!
        let urlComponents = NSURLComponents(string: url.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: "80"),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        if let token = MyUserDefaults.shared.getString(key: MyUserDefaults.tokenKey){
            let bearer = "Bearer " + token
            request.setValue(bearer, forHTTPHeaderField: "Authorization")
        }
       
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
                
                if let totalPage = httpURLResponse.allHeaderFields["x-wp-totalpages"] as? String{
                    MyUserDefaults.shared.saveInt(key: MyUserDefaults.totalPages, value: Int(totalPage) ?? 1)
                }
               
                // 5
                return response.data
            }
            // 6
            .decode(type: LocationResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK business list Api
    static func charityListApi(page: Int) -> AnyPublisher<CharityResponse, ApiError> {
        
        let url = URL(string:Constant.shared.getBaseUrl() + AuthServices.charitiesList)!
        let urlComponents = NSURLComponents(string: url.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: "80"),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        if let token = MyUserDefaults.shared.getString(key: MyUserDefaults.tokenKey){
            let bearer = "Bearer " + token
            request.setValue(bearer, forHTTPHeaderField: "Authorization")
        }
       
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
                
                if let totalPage = httpURLResponse.allHeaderFields["x-wp-totalpages"] as? String{
                    MyUserDefaults.shared.saveInt(key: MyUserDefaults.totalPages, value: Int(totalPage) ?? 1)
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
    
    
    //MARK Order list Api
    static func orderListApi(cusId: String) -> AnyPublisher<CustomerOrdersResponse, ApiError> {
        
        let url = URL(string:Constant.shared.getBaseUrl() + orderList + cusId + "/orders")!
        let urlComponents = NSURLComponents(string: url.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "consumer_key", value: Constant.shared.consumerKey),
            URLQueryItem(name: "consumer_secret", value: Constant.shared.consumerSecret)
        ]
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        if let token = MyUserDefaults.shared.getString(key: MyUserDefaults.userTokenKey){
            let bearer = "Bearer " + token
            request.setValue(bearer, forHTTPHeaderField: "Authorization")
        }
       
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
                // 5
                return response.data
            }
            // 6
            .decode(type: CustomerOrdersResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    //MARK: SignUp a Business
    func signUpBusiness(vc: UIViewController, bData: BusinessSignUpData) -> AnyPublisher<BusinessSignupResponse, ApiError>{
        
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + businessSignUp)!
        urlComponent.queryItems = [
            URLQueryItem(name: "consumer_key", value: Constant.shared.consumerKey),
            URLQueryItem(name: "consumer_secret", value: Constant.shared.consumerSecret)
        ]
        
         let jsonParams: [String: Any] =
            ["slug": bData.name,
             "status": "draft",
             "type": "businesses",
             "title":["raw": bData.name,
                      "rendered": bData.name],
             "fields": ["business_type": bData.businessType,
                        "description": bData.description,
                        "county": "Emmet",
                        "discount": bData.discount,
                        "image": "",
                        "address_1": bData.address,
                        "address_2": "",
                        "city": bData.city,
                        "zip_code": bData.zip,
                        "phone": bData.phone,
                        "website": bData.website,
                        "facebook": bData.facebook,
                        "instagram": bData.instagram]]
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
                    httpURLResponse.statusCode == 201
                else {
                    // 4
                    throw ApiError.statusCode
                }
                // 5
                return response.data
            }
            // 6
            .decode(type: BusinessSignupResponse.self, decoder: JSONDecoder())
            // 7
            .mapError { ApiError.map($0) }
            // 8
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Image Load
    static func loadImage(imageView: UIImageView, urlStr: String) {
        
        if let cached = cache[urlStr] {
            imageView.image = cached
            return
        }
        
        if let url = URL(string: urlStr){
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    imageView.image = UIImage(data: data)
                    self.cache[urlStr] = UIImage(data: data)
                }
            }
        }
    }
    
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
