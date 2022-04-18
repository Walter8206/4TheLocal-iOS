//
//  OrderResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 13/8/21.
//

import Foundation

// MARK: - OrderResponse
struct OrderResponse: Codable {
    let id, parentID: Int?
    let status, currency, version: String?
    let pricesIncludeTax: Bool
    let dateCreated, dateModified, discountTotal, discountTax: String?
    let shippingTotal, shippingTax, cartTax, total: String?
    let totalTax: String?
    let customerID: Int?
    let orderKey: String?
    let billing, shipping: Billing
    let paymentMethod, paymentMethodTitle, transactionID, customerIPAddress: String?
    let customerUserAgent, createdVia, customerNote: String?
    let dateCompleted: String??
    let datePaid, cartHash, number: String?
    let dateCreatedGmt, dateModifiedGmt: String?
    let dateCompletedGmt: String??
    let datePaidGmt, currencySymbol: String?

    enum CodingKeys: String, CodingKey {
        case id
        case parentID = "parent_id"
        case status, currency, version
        case pricesIncludeTax = "prices_include_tax"
        case dateCreated = "date_created"
        case dateModified = "date_modified"
        case discountTotal = "discount_total"
        case discountTax = "discount_tax"
        case shippingTotal = "shipping_total"
        case shippingTax = "shipping_tax"
        case cartTax = "cart_tax"
        case total
        case totalTax = "total_tax"
        case customerID = "customer_id"
        case orderKey = "order_key"
        case billing, shipping
        case paymentMethod = "payment_method"
        case paymentMethodTitle = "payment_method_title"
        case transactionID = "transaction_id"
        case customerIPAddress = "customer_ip_address"
        case customerUserAgent = "customer_user_agent"
        case createdVia = "created_via"
        case customerNote = "customer_note"
        case dateCompleted = "date_completed"
        case datePaid = "date_paid"
        case cartHash = "cart_hash"
        case number
        case dateCreatedGmt = "date_created_gmt"
        case dateModifiedGmt = "date_modified_gmt"
        case dateCompletedGmt = "date_completed_gmt"
        case datePaidGmt = "date_paid_gmt"
        case currencySymbol = "currency_symbol"
    }
}


//MARK: - LineItem
struct LineItem: Codable {
    let id: Int?
    let name: String?
    let productID, variationID, quantity: Int?
    let taxClass, subtotal, subtotalTax, total: String?
    let totalTax: String?
    let sku: String?
    let price: String?
    let parentName: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case productID = "product_id"
        case variationID = "variation_id"
        case quantity
        case taxClass = "tax_class"
        case subtotal
        case subtotalTax = "subtotal_tax"
        case total
        case totalTax = "total_tax"
        case sku, price
        case parentName = "parent_name"
    }
}


// MARK: - CouponLine
struct CouponLine: Codable {
    let id: Int?
    let code, discount, discountTax: String?

    enum CodingKeys: String, CodingKey {
        case id, code, discount
        case discountTax = "discount_tax"
    }
}
