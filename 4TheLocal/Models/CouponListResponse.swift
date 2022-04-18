//
//  CouponListResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 21/8/21.
//

import Foundation

// MARK: - CouponListResponseElement
struct CouponListResponseElement: Codable {
    var productName: String?
    var charityCoupon: [CharityCoupon?]?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case charityCoupon = "charity_coupon"
    }
}

// MARK: - CharityCoupon
struct CharityCoupon: Codable {
    var charitySlug, couponCode: String?

    enum CodingKeys: String, CodingKey {
        case charitySlug = "charity_slug"
        case couponCode = "coupon_code"
    }
}

typealias CouponListResponse = [CouponListResponseElement]
