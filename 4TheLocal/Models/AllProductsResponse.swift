//
//  AllProductsResponse.swift
//  4TheLocal
//
//  Created by Mahamudul on 12/8/21.
//

import Foundation

// MARK: - AllProductsResponse
struct AllProductsResponse: Codable {
    let products: [Product]
}

// MARK: - Product
struct Product: Codable {
    let title: String?
    let id: Int?
    let createdAt: String?
    let updatedAt: String?
    let type, status: String?
    let downloadable, virtual: Bool?
    let permalink: String?
    let sku, price, regularPrice: String?
    let salePrice:String?
    let priceHTML: String?
    let taxable: Bool?
    let taxStatus, taxClass: String?
    let managingStock: Bool?
    let stockQuantity:String?
    let inStock, backordersAllowed, backordered, soldIndividually: Bool?
    let purchaseable, featured, visible: Bool?
    let catalogVisibility: String?
    let onSale: Bool?
    let productURL, buttonText: String?
    let shippingRequired, shippingTaxable: Bool?
    let shippingClass: String?
    let shippingClassID:String?
    let productDescription, shortDescription: String?
    let reviewsAllowed: Bool?
    let averageRating: String?
    let ratingCount: Int?
    let relatedIDS, upsellIDS: [Int?]
    let parentID: Int?
    let categories, tags: [String?]
    let downloadLimit, downloadExpiry: Int?
    let downloadType, purchaseNote: String?
    let totalSales: Int?
    let menuOrder: Int?

    enum CodingKeys: String, CodingKey {
        case title, id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case type, status, downloadable, virtual, permalink, sku, price
        case regularPrice = "regular_price"
        case salePrice = "sale_price"
        case priceHTML = "price_html"
        case taxable
        case taxStatus = "tax_status"
        case taxClass = "tax_class"
        case managingStock = "managing_stock"
        case stockQuantity = "stock_quantity"
        case inStock = "in_stock"
        case backordersAllowed = "backorders_allowed"
        case backordered
        case soldIndividually = "sold_individually"
        case purchaseable, featured, visible
        case catalogVisibility = "catalog_visibility"
        case onSale = "on_sale"
        case productURL = "product_url"
        case buttonText = "button_text"
        case shippingRequired = "shipping_required"
        case shippingTaxable = "shipping_taxable"
        case shippingClass = "shipping_class"
        case shippingClassID = "shipping_class_id"
        case productDescription = "description"
        case shortDescription = "short_description"
        case reviewsAllowed = "reviews_allowed"
        case averageRating = "average_rating"
        case ratingCount = "rating_count"
        case relatedIDS = "related_ids"
        case upsellIDS = "upsell_ids"
        case parentID = "parent_id"
        case categories, tags
        case downloadLimit = "download_limit"
        case downloadExpiry = "download_expiry"
        case downloadType = "download_type"
        case purchaseNote = "purchase_note"
        case totalSales = "total_sales"
        case menuOrder = "menu_order"
    }
}
