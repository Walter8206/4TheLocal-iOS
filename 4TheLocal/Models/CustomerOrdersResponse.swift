//
//  CustomerOrdersResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 21/8/21.
//

import Foundation

// MARK: - CustomerOrdersResponse
struct CustomerOrdersResponse: Codable {
    let orders: [Order]
}

// MARK: - Order
struct Order: Codable {
    let id: Int?
    let orderNumber, orderKey: String?
    let createdAt, updatedAt, completedAt: String?
    let status, currency, total, subtotal: String?
    let totalLineItemsQuantity: Int?
    let totalTax, totalShipping, cartTax, shippingTax: String?
    let totalDiscount, shippingMethods: String?
    let billingAddress, shippingAddress: Billing?
    let note, customerIP, customerUserAgent: String?
    let customerID: Int?
    let viewOrderURL: String?
    let lineItems: [LineItem2]?
    let couponLines: [CouponLine]?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNumber = "order_number"
        case orderKey = "order_key"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case completedAt = "completed_at"
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
    }
}


// MARK: - LineItem
struct LineItem2: Codable {
    let id: Int?
    let subtotal, subtotalTax, total, totalTax: String?
    let price: String?
    let quantity: Int?
    let taxClass, name: String?
    let productID: Int?
    let sku: String?

    enum CodingKeys: String, CodingKey {
        case id, subtotal
        case subtotalTax = "subtotal_tax"
        case total
        case totalTax = "total_tax"
        case price, quantity
        case taxClass = "tax_class"
        case name
        case productID = "product_id"
        case sku
    }
}
