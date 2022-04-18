//
//  BusinessSignupResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 20/8/21.
//

import Foundation

// MARK: - BusinessSignupResponse
struct BusinessSignupResponse: Codable {
    let id: Int?
    let date, dateGmt: String?
    let guid: GUID
    let modified, modifiedGmt, password, slug: String?
    let status, type: String?
    let link: String?
    let title: GUID?
    let template: String?
    let permalinkTemplate: String?
    let generatedSlug: String?
    let acf: BAcf?
    let yoastHead: String?

    enum CodingKeys: String, CodingKey {
        case id, date
        case dateGmt = "date_gmt"
        case guid, modified
        case modifiedGmt = "modified_gmt"
        case password, slug, status, type, link, title, template
        case permalinkTemplate = "permalink_template"
        case generatedSlug = "generated_slug"
        case acf
        case yoastHead = "yoast_head"
    }
}


// MARK: - Acf
struct BAcf: Codable {
    let businessType: [String?]?
    let acfDescription, county, discount, address1: String?
    let city, zipCode, phone: String?
    let website, facebook, instagram: String?

    enum CodingKeys: String, CodingKey {
        case businessType = "business_type"
        case acfDescription = "description"
        case county, discount
        case address1 = "address_1"
        case city
        case zipCode = "zip_code"
        case phone, website, facebook, instagram
    }
}
