//
//  MUserDefaults.swift
//  4TheLocal
//
//  Created by Mahamudul on 29/7/21.
//

import Foundation

final class MyUserDefaults{
    
    static let shared = MyUserDefaults()
    var defaults: UserDefaults? = nil
    
    //MARK:- Variables
    static let tokenKey = "token_key"
    static let userTokenKey = "user_token_key"
    static let cusIdKey = "cusIdKey"
    static let emailKey = "email_key"
    static let nameKey = "name_key"
    static let totalPages = "business_page_num"
    static let userInfoKey = "userInfo_key"
    static let sortTypeKey = "sortType_key"
    static let cityFilterKey = "cityFilterKey"
    static let businessFilterKey = "businessFilterKey"
    static let isSchoolKey = "isSchoolKey"
    
    init() {
        defaults = UserDefaults.standard
    }
    
    //MARK:- Save data
    func saveInt(key: String, value: Int){
        defaults?.setValue(value, forKey: key)
    }
    
    func saveString(key: String, value: String?){
        defaults?.setValue(value, forKey: key)
    }
    
    
    func saveBool(key: String, value: Bool){
        defaults?.setValue(value, forKey: key)
    }
    
    func saveUserInfo(note: UserInfoResponse){
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(note)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: MyUserDefaults.userInfoKey)

        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    //**************************//
    
    //MARK:- Get Data
    func getInt(key: String)-> Int?{
        return defaults?.integer(forKey: key)
    }
    
    func getString(key: String)-> String?{
        return defaults?.string(forKey: key)
    }
    
    func getBool(key: String)-> Bool{
        return defaults!.bool(forKey: key)
    }
    
    
    func getUserInfo()-> UserInfoResponse?{
        // Read/Get Data
        if let data = UserDefaults.standard.data(forKey: MyUserDefaults.userInfoKey) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let note = try decoder.decode(UserInfoResponse.self, from: data)

                return note
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return nil
    }
    
    //*************************
    
    func clearAll(){
        defaults?.removeObject(forKey: MyUserDefaults.cusIdKey)
        //defaults?.removeObject(forKey: MyUserDefaults.tokenKey)
        defaults?.removeObject(forKey: MyUserDefaults.userTokenKey)
        defaults?.removeObject(forKey: MyUserDefaults.emailKey)
        defaults?.removeObject(forKey: MyUserDefaults.nameKey)
        defaults?.removeObject(forKey: MyUserDefaults.totalPages)
        defaults?.removeObject(forKey: MyUserDefaults.userInfoKey)
    }
}
