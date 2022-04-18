//
//  ApiError.swift
//  Tamo
//
//  Created by Mahamudul on 9/7/21.
//  Copyright © 2021 Robertas Pauzas. All rights reserved.
//

import Foundation

enum ApiError: Error {
  case statusCode
  case decoding
  case invalidURL
  case other(Error)
  
  static func map(_ error: Error) -> ApiError {
    return (error as? ApiError) ?? .other(error)
  }
}
