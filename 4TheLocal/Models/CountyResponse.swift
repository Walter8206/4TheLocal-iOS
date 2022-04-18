//
//  CountyResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 8/9/21.
//

import Foundation

// MARK: - CountyResponse
struct CountyResponse: Codable {
    let stateName, stateCode: String?
    let counties: [String]?

    enum CodingKeys: String, CodingKey {
        case stateName = "state_name"
        case stateCode = "state_code"
        case counties
    }
}
