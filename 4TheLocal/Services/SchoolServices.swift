//
//  SchoolServices.swift
//  4TheLocal
//
//  Created by Mahamudul on 8/9/21.
//

import Foundation
import Combine

class SchoolServices{
    
    static let shared = SchoolServices()
    
    static let states = "/wp-content/api/states.php"
    static let counties = "/wp-content/api/counties.php"
    static let schools = "/wp-content/api/schools.php"
    static let boosters = "/wp-content/api/boosters.php"
    static let students = "/wp-content/api/students.php"
    
    //MARK: Get States
    static func getStates() -> AnyPublisher<StateResponse, ApiError>{
        let urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + states)!
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: (urlComponent.url)!)
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { response in
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw ApiError.statusCode
                }
                return response.data
            }
            .decode(type: StateResponse.self, decoder: JSONDecoder())
            .mapError { ApiError.map($0) }
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Get Counties
    static func getCounties(stateCode: String) -> AnyPublisher<CountyResponse, ApiError>{
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + counties)!
        urlComponent.queryItems = [
            URLQueryItem(name: "state_code", value: stateCode)
        ]
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: (urlComponent.url)!)
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { response in
                
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw ApiError.statusCode
                }
                
                return response.data
            }
            .decode(type: CountyResponse.self, decoder: JSONDecoder())
            .mapError { ApiError.map($0) }
            .eraseToAnyPublisher()
    }
    
    
    //MARK: Get Schools
    static func getSchools(stateCode: String, county: String) -> AnyPublisher<SchoolsResponse, ApiError>{
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + schools)!
        urlComponent.queryItems = [
            URLQueryItem(name: "state_code", value: stateCode),
            URLQueryItem(name: "county", value: county)
        ]
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: (urlComponent.url)!)
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { response in
                
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw ApiError.statusCode
                }
                
                return response.data
            }
            .decode(type: SchoolsResponse.self, decoder: JSONDecoder())
            .mapError { ApiError.map($0) }
            .eraseToAnyPublisher()
    }
    
    
    
    //MARK: Get Boosters
    static func getBoosters(stateCode: String, county: String, schoolName: String) -> AnyPublisher<BoostersResponse, ApiError>{
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + boosters)!
        urlComponent.queryItems = [
            URLQueryItem(name: "state_code", value: stateCode),
            URLQueryItem(name: "county", value: county),
            URLQueryItem(name: "school_name", value: schoolName)
        ]
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: (urlComponent.url)!)
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { response in
                
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw ApiError.statusCode
                }
                
                return response.data
            }
            .decode(type: BoostersResponse.self, decoder: JSONDecoder())
            .mapError { ApiError.map($0) }
            .eraseToAnyPublisher()
    }
    
    //MARK: Get Students
    static func getStudents(stateCode: String,
                            county: String,
                            schoolName: String,
                            booster: String) -> AnyPublisher<StudentsResponse, ApiError>{
        var urlComponent = URLComponents(string: Constant.shared.getBaseUrl() + students)!
        urlComponent.queryItems = [
            URLQueryItem(name: "state_code", value: stateCode),
            URLQueryItem(name: "county", value: county),
            URLQueryItem(name: "school_name", value: schoolName),
            URLQueryItem(name: "booster", value: booster)
        ]
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: (urlComponent.url)!)
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { response in
                
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw ApiError.statusCode
                }
                
                return response.data
            }
            .decode(type: StudentsResponse.self, decoder: JSONDecoder())
            .mapError { ApiError.map($0) }
            .eraseToAnyPublisher()
    }
}
