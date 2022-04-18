//
//  SubscribtionResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 1/9/21.
//

import Foundation


// MARK: - SubscribtionResponse
struct SubscribtionResponse: Codable {
    let subscription: Subscription
}

// MARK: - Subscription
struct Subscription: Codable {
    let id: Int?
    let orderNumber, orderKey: String?
    let createdAt, updatedAt: String?
    let status, currency, total, subtotal: String?
    let totalLineItemsQuantity: Int?
    let totalTax, totalShipping, cartTax, shippingTax: String?
    let totalDiscount, shippingMethods: String?
    let billingAddress, shippingAddress: Billing?
    let note, customerIP, customerUserAgent: String?
    let customerID: Int?
    let viewOrderURL: String?
    let parentOrderID: Int?

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
        case parentOrderID = "parent_order_id"
    }
}
