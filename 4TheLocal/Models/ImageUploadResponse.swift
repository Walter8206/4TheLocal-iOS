//
//  ImageUploadResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 17/8/21.
//

import Foundation

// MARK: - ImageUploadResponse
struct ImageUploadResponse: Codable {
    let id: Int?
    let date, dateGmt: String?
    let guid: Caption?
    let modified, modifiedGmt, slug, status: String?
    let type: String?
    let link: String?
    let title: Caption?
    let author: Int?
    let commentStatus, pingStatus, template: String?
    let permalinkTemplate: String?
    let generatedSlug: String?
    let acf: [Acf]?
    let yoastHead: String?
    let imageUploadResponseDescription, caption: Caption?
    let altText, mediaType, mimeType: String?
    let post: String??
    let sourceURL: String?

    enum CodingKeys: String, CodingKey {
        case id, date
        case dateGmt = "date_gmt"
        case guid, modified
        case modifiedGmt = "modified_gmt"
        case slug, status, type, link, title, author
        case commentStatus = "comment_status"
        case pingStatus = "ping_status"
        case template
        case permalinkTemplate = "permalink_template"
        case generatedSlug = "generated_slug"
        case acf
        case yoastHead = "yoast_head"
        case imageUploadResponseDescription = "description"
        case caption
        case altText = "alt_text"
        case mediaType = "media_type"
        case mimeType = "mime_type"
        case post
        case sourceURL = "source_url"
    }
}

// MARK: - Caption
struct Caption: Codable {
    let raw, rendered: String?
}



// MARK: - Author
struct Author: Codable {
    let embeddable: Bool
    let href: String?
}

