//
//  PaymentErrore.swift
//  4TheLocal
//
//  Created by Mahamudul on 17/8/21.
//

import Foundation

// MARK: - PaymentErrore
struct PaymentErroreResponse: Codable {
    let error: PError
}

// MARK: - Error
struct PError: Codable {
    let code: String
    let docURL: String
    let message, param, type: String

    enum CodingKeys: String, CodingKey {
        case code
        case docURL = "doc_url"
        case message, param, type
    }
}
