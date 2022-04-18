//
//  CreateCustomerResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 12/8/21.
//

import Foundation

// MARK: - CreateCustomerResponse
struct CreateCustomerResponse: Codable {
    let id: Int?
    let dateCreated, dateCreatedGmt, dateModified, dateModifiedGmt: String?
    let email, firstName, lastName, role: String?
    let username: String?
    let billing: Billing?

    enum CodingKeys: String, CodingKey {
        case id
        case dateCreated = "date_created"
        case dateCreatedGmt = "date_created_gmt"
        case dateModified = "date_modified"
        case dateModifiedGmt = "date_modified_gmt"
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case role, username, billing
    }
}

// MARK: - Ing
struct Billing: Codable {
    let firstName, lastName, company, address1: String?
    let address2, city, postcode, country: String?
    let state: String?
    let email, phone: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case company
        case address1 = "address_1"
        case address2 = "address_2"
        case city, postcode, country, state, email, phone
    }
}
