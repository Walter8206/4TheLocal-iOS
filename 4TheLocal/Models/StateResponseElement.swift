//
//  StateResponseElement.swift
//  4TheLocal
//
//  Created by Mahamudul on 8/9/21.
//

import Foundation

// MARK: - StateResponseElement
struct StateResponseElement: Codable {
    let stateCode, stateName: String?

    enum CodingKeys: String, CodingKey {
        case stateCode = "state_code"
        case stateName = "state_name"
    }
}

typealias StateResponse = [StateResponseElement]

