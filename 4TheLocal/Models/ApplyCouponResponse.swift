//
//  CouponResponseElement.swift
//  4TheLocal
//
//  Created by Mahamudul on 14/8/21.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let couponResponse = try? newJSONDecoder().decode(CouponResponse.self, from: jsonData)

import Foundation

// MARK: - CouponResponseElement
struct ApplyCouponResponse: Codable {
    let id: Int?
    let code, amount, dateCreated, dateCreatedGmt: String?
    let dateModified, dateModifiedGmt, discountType, couponResponseDescription: String?
    let dateExpires, dateExpiresGmt: String?
    let usageCount: Int?
    let individualUse: Bool
    let productIDS: [Int?]
    let usageLimit: String?
    let usageLimitPerUser: Int?
    let limitUsageToXItems: String?
    let freeShipping: Bool
    let excludeSaleItems: Bool
    let minimumAmount, maximumAmount: String?
    let usedBy: [String?]

    enum CodingKeys: String, CodingKey {
        case id, code, amount
        case dateCreated = "date_created"
        case dateCreatedGmt = "date_created_gmt"
        case dateModified = "date_modified"
        case dateModifiedGmt = "date_modified_gmt"
        case discountType = "discount_type"
        case couponResponseDescription = "description"
        case dateExpires = "date_expires"
        case dateExpiresGmt = "date_expires_gmt"
        case usageCount = "usage_count"
        case individualUse = "individual_use"
        case productIDS = "product_ids"
        case usageLimit = "usage_limit"
        case usageLimitPerUser = "usage_limit_per_user"
        case limitUsageToXItems = "limit_usage_to_x_items"
        case freeShipping = "free_shipping"
        case excludeSaleItems = "exclude_sale_items"
        case minimumAmount = "minimum_amount"
        case maximumAmount = "maximum_amount"
        case usedBy = "used_by"
    }
}

typealias ApplyCoupon = [ApplyCouponResponse]
