//
//  CreateSubscribtionResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 1/9/21.
//

import Foundation


// MARK: - CreateSubscribtionResponse
struct CreateSubscribtionResponse: Codable {
    let creatingSubscription: CreatingSubscription?

    enum CodingKeys: String, CodingKey {
        case creatingSubscription = "creating_subscription"
    }
}

// MARK: - CreatingSubscription
struct CreatingSubscription: Codable {
    let subscription: Subscription2
    
    enum CodingKeys: String, CodingKey {
        case subscription = "subscription"
    }
}

// MARK: - Subscription
struct Subscription2: Codable {
    let id: Int?
    let orderNumber, orderKey: String?
    let createdAt, updatedAt: String?
    let status, currency, total, subtotal: String?
    let totalLineItemsQuantity: Int?
    let totalTax, totalShipping, cartTax, shippingTax: String?
    let totalDiscount, shippingMethods: String?
    let billingAddress, shippingAddress: Billing
    let note, customerIP, customerUserAgent: String?
    let customerID: Int?
    let viewOrderURL: String?
    let lineItems: [LineItem]
    let couponLines: [CouponLine]
    //let parentOrderID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNumber = "order_number"
        case orderKey = "order_key"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status, currency, total, subtotal
        case totalLineItemsQuantity = "total_line_items_quantity"
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
        case lineItems = "line_items"
        case couponLines = "coupon_lines"
        //case parentOrderID = "parent_order_id"
    }
}
