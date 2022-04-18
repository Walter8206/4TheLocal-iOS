//
//  LoginResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 29/7/21.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    
    let id: Int?
    let token: String?
    let userEmail: String?
    let userNicename : String?
    let userDisplayName: String?

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case token = "token"
        case userEmail = "user_email"
        case userNicename = "user_nicename"
        case userDisplayName = "user_display_name"
    }
}
