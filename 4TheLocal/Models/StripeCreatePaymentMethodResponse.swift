//
//  StripeCreatePaymentMethodResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 13/8/21.
//

import Foundation


// MARK: - StripeCreatePaymentMethodResponse
struct StripeCreatePaymentMethodResponse: Codable {
    let id, object: String?
    let billingDetails: BillingDetails
    let card: Card
    let created: Int?
    let customer: String?
    let livemode: Bool
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id, object
        case billingDetails = "billing_details"
        case card, created, customer, livemode, type
    }
}


// MARK: - BillingDetails
struct BillingDetails: Codable {
    let address: Address
    let email, name, phone: String?
}

// MARK: - Address
struct Address: Codable {
    let city, country, line1, line2: String?
    let postalCode, state: String?

    enum CodingKeys: String, CodingKey {
        case city, country, line1, line2
        case postalCode = "postal_code"
        case state
    }
}

// MARK: - Card
struct Card: Codable {
    let brand: String?
    let country: String?
    let expMonth, expYear: Int?
    let fingerprint, funding: String?
    let generatedFrom: String?
    let last4: String?
    let wallet: String?

    enum CodingKeys: String, CodingKey {
        case brand, country
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case fingerprint, funding
        case generatedFrom = "generated_from"
        case last4
        case wallet
    }
}
