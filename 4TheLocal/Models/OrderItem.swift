//
//  OrderItem.swift
//  4TheLocal
//
//  Created by Mahamudul on 17/8/21.
//

import Foundation

class OrderItem {
    
    var id: Int?
    var title: String?
    var price: Double?
    var orderType: Int? // type 1 for product and 2 for coupon
    var itemCount = 1
}
