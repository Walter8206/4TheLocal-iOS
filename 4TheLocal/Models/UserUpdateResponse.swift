//
//  UserUpdateResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 19/8/21.
//

import Foundation


// MARK: - UserUpdateResponse
struct UserUpdateResponse: Codable {
    let id: Int?
    let dateCreated, dateCreatedGmt, dateModified, dateModifiedGmt: String?
    let email, firstName, lastName, role: String?
    let username: String?
    let billing, shipping: Billing?
    let isPayingCustomer: Bool
    let avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case dateCreated = "date_created"
        case dateCreatedGmt = "date_created_gmt"
        case dateModified = "date_modified"
        case dateModifiedGmt = "date_modified_gmt"
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case role, username, billing, shipping
        case isPayingCustomer = "is_paying_customer"
        case avatarURL = "avatar_url"
    }
}
