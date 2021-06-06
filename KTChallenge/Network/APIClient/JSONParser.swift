//
//  JSONParser.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//

import Foundation

public class JSONParser {
    public class func encode<T: Encodable>(value: T) throws -> Data? {
        let jsonEncoder = JSONEncoder()
        return try jsonEncoder.encode(value)
    }
    
    public class func decode<T: Decodable>(value: Data) throws -> T {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(T.self, from: value)
    }
}
