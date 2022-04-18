//
//  SchoolsResponseElement.swift
//  4TheLocal
//
//  Created by Mahamudul on 8/9/21.
//

import Foundation

// MARK: - SchoolsResponseElement
struct SchoolsResponseElement: Codable {
    let state, countyName, schoolName: String?

    enum CodingKeys: String, CodingKey {
        case state
        case countyName = "county_name"
        case schoolName = "school_name"
    }
}

typealias SchoolsResponse = [SchoolsResponseElement]
