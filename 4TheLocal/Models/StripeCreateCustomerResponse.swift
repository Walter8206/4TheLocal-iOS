//
//  StripeCreateCustomerResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 13/8/21.
//

import Foundation

// MARK: - StripeCreateCustomerResponse
struct StripeCreateCustomerResponse: Codable {
    let id, object: String?
    let address: String?
    let balance, created: Int?
    let currency, defaultSource: String?
    let delinquent: Bool
    let stripeCreateCustomerResponseDescription, discount: String?
    let email: String?
    let livemode: Bool
    let name: String?
    let nextInvoiceSequence: Int?
    let phone: String?
    let shipping: String?
    let taxExempt: String?

    enum CodingKeys: String, CodingKey {
        case id, object, address, balance, created, currency
        case defaultSource = "default_source"
        case delinquent
        case stripeCreateCustomerResponseDescription = "description"
        case discount, email
        case livemode, name
        case nextInvoiceSequence = "next_invoice_sequence"
        case phone
        case shipping
        case taxExempt = "tax_exempt"
    }
}
