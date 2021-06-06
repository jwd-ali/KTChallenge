//
//  City.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//

import Foundation
protocol CityType {
    var name: String { get }
    var country: String { get }
    var state: String { get }
}

struct City: CityType, Hashable {
    let uuid = UUID()
    let name: String
    let country: String
    let state: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}


extension City: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case state = "adminName1"
        case country = "countryName"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: City.CodingKeys.self)
        name = (try? container.decode(String?.self, forKey: .name)) ?? ""
        country = (try? container.decode(String?.self, forKey: .country)) ?? ""
        state = (try? container.decode(String?.self, forKey: .state)) ?? ""
    }
}

extension City {
    static var mocked: [City] {
        [City(name: "MockName", country: "MockCountry", state: "MockState")]
    }
}

struct Cities: Decodable, Hashable {
    let totalResultsCount: Int
    let geonames: [City]
}
