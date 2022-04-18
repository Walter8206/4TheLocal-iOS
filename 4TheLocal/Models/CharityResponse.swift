// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let charityResponse = try? newJSONDecoder().decode(CharityResponse.self, from: jsonData)

import Foundation

// MARK: - CharityResponseElement
struct CharityResponseElement: Codable {
    let id: Int?
    let date, dateGmt: String?
    let guid: GUID?
    let modified, modifiedGmt, slug: String?
    let status: CharityResponseStatus
    let type: CharityResponseType
    let link: String?
    let title: GUID
    let featuredMedia: Int
    let template: String?
    let meta: Meta
    let acf: CAcf
    let yoastHead: String?

    enum CodingKeys: String, CodingKey {
        case id, date
        case dateGmt = "date_gmt"
        case guid, modified
        case modifiedGmt = "modified_gmt"
        case slug, status, type, link, title
        case featuredMedia = "featured_media"
        case template, meta, acf
        case yoastHead = "yoast_head"
    }
}

// MARK: - Acf
struct CAcf: Codable {
    let charityType: [String?]?
    let acfDescription: String?
    let county: String?
    let image: Image
    let address1, address2, city, zipCode: String?
    let phone: String?
    let website: String?
    let facebook, instagram: String?

    enum CodingKeys: String, CodingKey {
        case charityType = "charity_type"
        case acfDescription = "description"
        case county, image
        case address1 = "address_1"
        case address2 = "address_2"
        case city
        case zipCode = "zip_code"
        case phone, website, facebook, instagram
    }
}

// MARK: - Meta
struct Meta: Codable {
    let etPbUseBuilder, etPbOldContent, etGBContentWidth: String?

    enum CodingKeys: String, CodingKey {
        case etPbUseBuilder = "_et_pb_use_builder"
        case etPbOldContent = "_et_pb_old_content"
        case etGBContentWidth = "_et_gb_content_width"
    }
}

enum CharityResponseStatus: String, Codable {
    case publish = "publish"
}

enum CharityResponseType: String, Codable {
    case charities = "charities"
}

typealias CharityResponse = [CharityResponseElement]
