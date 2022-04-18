//
//  StudentsResponseElement.swift
//  4TheLocal
//
//  Created by Mahamudul on 8/9/21.
//

import Foundation

// MARK: - StudentsResponseElement
struct StudentsResponseElement: Codable {
    let state, countyName, booster: String?
    let students: [Student?]?

    enum CodingKeys: String, CodingKey {
        case state
        case countyName = "county_name"
        case booster, students
    }
}

// MARK: - Student
struct Student: Codable {
    let firstName, lastName: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

typealias StudentsResponse = [StudentsResponseElement]
