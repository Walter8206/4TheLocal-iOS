//
//  StripePaymentInt?entResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 13/8/21.
//

import Foundation

// MARK: - StripePaymentInt?entResponse
struct StripePaymentIntentResponse: Codable {
    let id, object: String?
    let amount, amountCapturable, amountReceived: Int?
    let application, applicationFeeAmount, canceledAt, cancellationReason: String?
    let captureMethod: String?
    let clientSecret, confirmationMethod: String?
    let created: Int?
    let currency, customer: String?
    let stripePaymentIntentResponseDescription, invoice, lastPaymentError: String?
    let livemode: Bool?
    let nextAction, onBehalfOf, paymentMethod: String?
    let paymentMethodTypes: [String?]?
    let receiptEmail, review, setupFutureUsage, shipping: String?
    let source, statementDescriptor, statementDescriptorSuffix: String?
    let status: String?
    let transferData, transferGroup: String?

    enum CodingKeys: String, CodingKey {
        case id, object, amount
        case amountCapturable = "amount_capturable"
        case amountReceived = "amount_received"
        case application
        case applicationFeeAmount = "application_fee_amount"
        case canceledAt = "canceled_at"
        case cancellationReason = "cancellation_reason"
        case captureMethod = "capture_method"
        case clientSecret = "client_secret"
        case confirmationMethod = "confirmation_method"
        case created, currency, customer
        case stripePaymentIntentResponseDescription = "description"
        case invoice
        case lastPaymentError = "last_payment_error"
        case livemode
        case nextAction = "next_action"
        case onBehalfOf = "on_behalf_of"
        case paymentMethod = "payment_method"
        case paymentMethodTypes = "payment_method_types"
        case receiptEmail = "receipt_email"
        case review
        case setupFutureUsage = "setup_future_usage"
        case shipping, source
        case statementDescriptor = "statement_descriptor"
        case statementDescriptorSuffix = "statement_descriptor_suffix"
        case status
        case transferData = "transfer_data"
        case transferGroup = "transfer_group"
    }
}
