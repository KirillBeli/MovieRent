//
//  ErrorHandler.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 20.03.2023.
//

import Foundation

//MARK: - Error Manager
enum NetworkManagerError {
    case errorResponse(URLResponse?)
    case errorLocalUrl
    case errorData
    
    var errorDescription: String? {
        switch self {
        case .errorResponse:
            return "Error Response"
        case .errorLocalUrl:
            return "Error Local URL"
        case .errorData:
            return "Error Data"
        }
    }
   
   
    
}
