//
//  BoostersResponseElement.swift
//  4TheLocal
//
//  Created by Mahamudul on 8/9/21.
//

import Foundation

// MARK: - BoostersResponseElement
struct BoostersResponseElement: Codable {
    let state, countyName, booster: String?

    enum CodingKeys: String, CodingKey {
        case state
        case countyName = "county_name"
        case booster
    }
}

typealias BoostersResponse = [BoostersResponseElement]
