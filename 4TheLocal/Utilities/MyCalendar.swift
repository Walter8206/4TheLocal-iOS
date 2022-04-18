//
//  MyCalendar.swift
//  4TheLocal
//
//  Created by Mahamudul on 20/8/21.
//

import Foundation

class MyCalendar{
    
    static let dateFormate = "dd MMM, yyyy"
    static let apiDateFormate = "yyyy-MM-dd HH:mm:ss"
    static let timeFormate = "h:mm a"
    
    //get current date in string
    static func getCurrentDate() -> String {
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormate
        let dateInFormat = dateFormatter.string(from: todaysDate as Date)
        return dateInFormat
    }
    
    static func getCurrentTime() -> String {
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeFormate
        let dateInFormat = dateFormatter.string(from: todaysDate as Date)
        return dateInFormat
    }
    
    static func getDateForApi() -> String {
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = apiDateFormate
        let dateInFormat = dateFormatter.string(from: todaysDate as Date)
        return dateInFormat
    }
}
