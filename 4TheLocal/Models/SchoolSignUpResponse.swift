//
//  SchoolSignUpResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 17/9/21.
//

import Foundation

// MARK: - SchoolSignUpResponse
struct SchoolSignUpResponse: Codable {
    let creatingSubscription: CreatingSubscription?

    enum CodingKeys: String, CodingKey {
        case creatingSubscription = "creating_subscription"
    }
}

// MARK: - CreatingSubscription
struct CreatingSubscription2: Codable {
    let subscription: Subscription3?
}

// MARK: - Subscription
struct Subscription3: Codable {
    let id: Int?
    let orderNumber, orderKey: String?
    let createdAt, updatedAt: String?
    let status, currency, total, subtotal: String?
    //let totalLineItemsQuantity: Int?
    let totalTax, totalShipping, cartTax, shippingTax: String?
    let totalDiscount, shippingMethods: String?
    let billingAddress, shippingAddress: IngAddress?
    let note, customerIP, customerUserAgent: String?
    let customerID: Int?
    let viewOrderURL: String?
    //let lineItems: [LineItem]?
    //let couponLines: [CouponLine]?
    let billingSchedule: BillingSchedule?
    //let parentOrderID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNumber = "order_number"
        case orderKey = "order_key"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status, currency, total, subtotal
        //case totalLineItemsQuantity = "total_line_items_quantity"
        case totalTax = "total_tax"
        case totalShipping = "total_shipping"
        case cartTax = "cart_tax"
        case shippingTax = "shipping_tax"
        case totalDiscount = "total_discount"
        case shippingMethods = "shipping_methods"
        case billingAddress = "billing_address"
        case shippingAddress = "shipping_address"
        case note
        case customerIP = "customer_ip"
        case customerUserAgent = "customer_user_agent"
        case customerID = "customer_id"
        case viewOrderURL = "view_order_url"
        //case lineItems = "line_items"
        //case couponLines = "coupon_lines"
        case billingSchedule = "billing_schedule"
        //case parentOrderID = "parent_order_id"
    }
}

// MARK: - IngAddress
struct IngAddress: Codable {
    let firstName, lastName, company, address1: String?
    let address2, city, state, postcode: String?
    let country: String?
    let email, phone: String??

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case company
        case address1 = "address_1"
        case address2 = "address_2"
        case city, state, postcode, country, email, phone
    }
}

// MARK: - BillingSchedule
struct BillingSchedule: Codable {
    let period, Interval: String?
    let startAt: String?
    let trialEndAt, nextPaymentAt, endAt: String?

    enum CodingKeys: String, CodingKey {
        case period, Interval
        case startAt = "start_at"
        case trialEndAt = "trial_end_at"
        case nextPaymentAt = "next_payment_at"
        case endAt = "end_at"
    }
}

