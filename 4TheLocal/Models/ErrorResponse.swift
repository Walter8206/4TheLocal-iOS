//
//  ErrorResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 13/8/21.
//

import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let code, message: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let status: Int?
}
