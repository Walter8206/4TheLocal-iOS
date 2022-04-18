//
//  ForgotPassResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 26/8/21.
//

import Foundation

// MARK: - ForgotPassResponse
struct ForgotPassResponse: Codable {
    let code: Int?
    let message: String?
    let data: DataClass?
}
