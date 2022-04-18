//
//  BusinessResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 29/7/21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let businessResponse = try? newJSONDecoder().decode(BusinessResponse.self, from: jsonData)

import Foundation

// MARK: - BusinessResponse
struct BusinessResponseElement: Codable {
    let id: Int?
    let date, dateGmt: String?
    let guid: GUID?
    let modified, modifiedGmt, slug: String?
    let status: BusinessResponseStatus?
    let type: BusinessResponseType?
    let link: String?
    let title: GUID?
    let template: String?
    let acf: Acf?
    let yoastHead: String?

    enum CodingKeys: String, CodingKey {
        case id, date
        case dateGmt = "date_gmt"
        case guid, modified
        case modifiedGmt = "modified_gmt"
        case slug, status, type, link, title, template, acf
        case yoastHead = "yoast_head"
    }
}

// MARK: - Acf
struct Acf: Codable {
    let businessType: [String?]?
    let acfDescription: String?
    let county: String?
    let discount: String?
    let image: Image?
    let address1, address2, city, zipCode: String?
    let phone: String?
    let website: String?
    let facebook, instagram: String?
    let mapLocation: MapLocation?

    enum CodingKeys: String, CodingKey {
        case businessType = "business_type"
        case acfDescription = "description"
        case county, discount, image
        case address1 = "address_1"
        case address2 = "address_2"
        case city
        case zipCode = "zip_code"
        case phone, website, facebook, instagram
        case mapLocation = "map_location"
    }
}

enum BusinessType: Codable {
    case string(String?)
    case stringArray([String?]?)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(BusinessType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for BusinessType"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .stringArray(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Image
struct Image: Codable {
    let id, imageID: Int?
    let title, filename: String?
    let filesize: Int?
    let url: String?
    let link: String?
    let alt, author, imageDescription: String?
    let caption: String?
    let name: String?
    let status: ImageStatus?
    let uploadedTo: Int?
    let date, modified: String?
    let menuOrder: Int?
    let mimeType: MIMEType?
    let type: ImageType?
    let subtype: Subtype?
    let icon: String?
    let width, height: Int?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case imageID = "id"
        case title, filename, filesize, url, link, alt, author
        case imageDescription = "description"
        case caption, name, status
        case uploadedTo = "uploaded_to"
        case date, modified
        case menuOrder = "menu_order"
        case mimeType = "mime_type"
        case type, subtype, icon, width, height
    }
}

// MARK: - MapLocation
struct MapLocation: Codable {
    let address: String?
    let lat, lng: Double?
    let zoom: Int?
    let placeID, name, streetNumber, streetName: String?
    let streetNameShort, city, state, stateShort: String?
    let postCode, country, countryShort: String?

    enum CodingKeys: String, CodingKey {
        case address, lat, lng, zoom
        case placeID = "place_id"
        case name
        case streetNumber = "street_number"
        case streetName = "street_name"
        case streetNameShort = "street_name_short"
        case city, state
        case stateShort = "state_short"
        case postCode = "post_code"
        case country
        case countryShort = "country_short"
    }
}


enum MIMEType: String, Codable {
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
}

enum ImageStatus: String, Codable {
    case inherit = "inherit"
}

enum Subtype: String, Codable {
    case jpeg = "jpeg"
    case png = "png"
}

enum ImageType: String, Codable {
    case image = "image"
}

// MARK: - GUID
struct GUID: Codable {
    let rendered: String?
}

// MARK: - About
struct About: Codable {
    let href: String?
}

// MARK: - Cury
struct Cury: Codable {
    let name: Name?
    let href: Href?
    let templated: Bool?
}

enum Href: String, Codable {
    case httpsAPIWOrgRel = "https://api.w.org/{rel}"
}

enum Name: String, Codable {
    case wp = "wp"
}

enum BusinessResponseStatus: String, Codable {
    case publish = "publish"
}

enum BusinessResponseType: String, Codable {
    case businesses = "businesses"
}

typealias LocationResponse = [BusinessResponseElement]?

