//
//  UserInfoResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 18/8/21.
//

import Foundation

// MARK: - UserInfoResponse
struct UserInfoResponse: Codable {
    let id: Int?
    let dateCreated, dateCreatedGmt, dateModified, dateModifiedGmt: String?
    let email, firstName, lastName, role: String?
    let username: String?
    let billing, shipping: Billing?
    let isPayingCustomer: Bool
    let avatarURL: String?
    let metaData: [MetaDatum]

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
        case metaData = "meta_data"
    }
}


// MARK: - MetaDatum
struct MetaDatum: Codable {
    let id: Int?
    let key: String?
    let value: MetaDatumValue?
}

enum MetaDatumValue: Codable {
    case string(String)
    case unionArray([ValueElement])
    case valueClass(ValueClass)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([ValueElement].self) {
            self = .unionArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(ValueClass.self) {
            self = .valueClass(x)
            return
        }
        throw DecodingError.typeMismatch(MetaDatumValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MetaDatumValue"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .unionArray(let x):
            try container.encode(x)
        case .valueClass(let x):
            try container.encode(x)
        }
    }
}

enum ValueElement: Codable {
    case integerValue(Int)
    case stringValue(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integerValue(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .stringValue(x)
            return
        }
        throw DecodingError.typeMismatch(ValueElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ValueElement"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integerValue(let x):
            try container.encode(x)
        case .stringValue(let x):
            try container.encode(x)
        }
    }
}

// MARK: - ValueClass
struct ValueClass: Codable {
    let normal, side, column3, column4: String?
}

