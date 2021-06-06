//
//  SearchNetworkRouter.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//

import Foundation
enum SearchNetworkRouter <T: Codable>: URLRequestConvertible, Convertible {
    case searchLocations(RouterInput<T>)
    
    
    private var method: HTTPMethod {
        switch self {
        case .searchLocations:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .searchLocations:
            return "/searchJSON"
        }
    }
    
    private var input: RouterInput<T>? {
        switch self {
        case .searchLocations(let input):
            return input
        }
    }
    
    func urlRequest() throws -> URLRequest {
        return try urlRequest(path: path, method: method, input: input)
    }
}
