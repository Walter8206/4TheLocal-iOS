//
//  StripeConfirmPaymentInt?entResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 13/8/21.
//

import Foundation

// MARK: - StripeConfirmPaymentIntentResponse
struct StripeConfirmPaymentIntentResponse: Codable {
    let id, object: String?
    let amount, amountCapturable, amountReceived: Int?
    let application, applicationFeeAmount, canceledAt, cancellationReason: String?
    let captureMethod: String?
    let charges: Charges
    let clientSecret, confirmationMethod: String?
    let created: Int?
    let currency, customer: String?
    let stripeConfirmPaymentIntentResponseDescription, invoice, lastPaymentError: String?
    let livemode: Bool
    let metadata: Metadata
    let nextAction, onBehalfOf: String?
    let paymentMethod: String?
    let paymentMethodOptions: PaymentMethodOptions
    let paymentMethodTypes: [String?]
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
        case charges
        case clientSecret = "client_secret"
        case confirmationMethod = "confirmation_method"
        case created, currency, customer
        case stripeConfirmPaymentIntentResponseDescription = "description"
        case invoice
        case lastPaymentError = "last_payment_error"
        case livemode, metadata
        case nextAction = "next_action"
        case onBehalfOf = "on_behalf_of"
        case paymentMethod = "payment_method"
        case paymentMethodOptions = "payment_method_options"
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

// MARK: - Datum
struct Datum: Codable {
    let id, object: String?
    let amount, amountCaptured, amountRefunded: Int?
    let application, applicationFee, applicationFeeAmount: String?
    let balanceTransaction: String?
    let calculatedStatementDescriptor: String?
    let captured: Bool
    let created: Int?
    let currency, customer: String?
    let datumDescription, destination, dispute: String?
    let disputed: Bool
    let failureCode, failureMessage: String?
    let fraudDetails: Metadata
    let invoice: String?
    let livemode: Bool
    let metadata: Metadata
    let onBehalfOf, order: String?
    let outcome: Outcome
    let paid: Bool
    let paymentIntent, paymentMethod: String?
    let paymentMethodDetails: PaymentMethodDetails
    let receiptEmail, receiptNumber: String?
    let receiptURL: String?
    let refunded: Bool
    let refunds: Charges
    let review, shipping, source, sourceTransfer: String?
    let statementDescriptor, statementDescriptorSuffix: String?
    let status: String?
    let transferData, transferGroup: String?

    enum CodingKeys: String, CodingKey {
        case id, object, amount
        case amountCaptured = "amount_captured"
        case amountRefunded = "amount_refunded"
        case application
        case applicationFee = "application_fee"
        case applicationFeeAmount = "application_fee_amount"
        case balanceTransaction = "balance_transaction"
        case calculatedStatementDescriptor = "calculated_statement_descriptor"
        case captured, created, currency, customer
        case datumDescription = "description"
        case destination, dispute, disputed
        case failureCode = "failure_code"
        case failureMessage = "failure_message"
        case fraudDetails = "fraud_details"
        case invoice, livemode, metadata
        case onBehalfOf = "on_behalf_of"
        case order, outcome, paid
        case paymentIntent = "payment_intent"
        case paymentMethod = "payment_method"
        case paymentMethodDetails = "payment_method_details"
        case receiptEmail = "receipt_email"
        case receiptNumber = "receipt_number"
        case receiptURL = "receipt_url"
        case refunded, refunds, review, shipping, source
        case sourceTransfer = "source_transfer"
        case statementDescriptor = "statement_descriptor"
        case statementDescriptorSuffix = "statement_descriptor_suffix"
        case status
        case transferData = "transfer_data"
        case transferGroup = "transfer_group"
    }
}

// MARK: - Charges
struct Charges: Codable {
    let object: String?
    let data: [Datum]
    let hasMore: Bool
    let totalCount: Int?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case object, data
        case hasMore = "has_more"
        case totalCount = "total_count"
        case url
    }
}

// MARK: - Metadata
struct Metadata: Codable {
}

// MARK: - Outcome
struct Outcome: Codable {
    let networkStatus: String?
    let reason: String?
    let riskLevel: String?
    let riskScore: Int?
    let sellerMessage, type: String?

    enum CodingKeys: String, CodingKey {
        case networkStatus = "network_status"
        case reason
        case riskLevel = "risk_level"
        case riskScore = "risk_score"
        case sellerMessage = "seller_message"
        case type
    }
}

// MARK: - PaymentMethodDetails
struct PaymentMethodDetails: Codable {
    let card: PaymentMethodDetailsCard
    let type: String?
}

// MARK: - PaymentMethodDetailsCard
struct PaymentMethodDetailsCard: Codable {
    let brand: String?
    let checks: Checks
    let country: String?
    let expMonth, expYear: Int?
    let fingerprint, funding: String?
    let installments: String?
    let last4, network: String?
    let threeDSecure, wallet: String?

    enum CodingKeys: String, CodingKey {
        case brand, checks, country
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case fingerprint, funding, installments, last4, network
        case threeDSecure = "three_d_secure"
        case wallet
    }
}

// MARK: - Checks
struct Checks: Codable {
    let addressLine1Check, addressPostalCodeCheck: String?
    let cvcCheck: String?

    enum CodingKeys: String, CodingKey {
        case addressLine1Check = "address_line1_check"
        case addressPostalCodeCheck = "address_postal_code_check"
        case cvcCheck = "cvc_check"
    }
}

// MARK: - PaymentMethodOptions
struct PaymentMethodOptions: Codable {
    let card: PaymentMethodOptionsCard
}

// MARK: - PaymentMethodOptionsCard
struct PaymentMethodOptionsCard: Codable {
    let installments, network: String?
    let requestThreeDSecure: String?

    enum CodingKeys: String, CodingKey {
        case installments, network
        case requestThreeDSecure = "request_three_d_secure"
    }
}
