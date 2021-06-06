//
//  SearchService.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//

import Combine
typealias completion<T: Decodable> = (Result<T, NetworkRequestError>) -> Void

protocol SearchServiceType {
    func searchLocation<T: Decodable>(nameSufix: String, maxRows: Int, username: String) -> AnyPublisher<T, NetworkRequestError>
}

class SearchService: SearchServiceType {
    private let apiClient: ApiService
    
    init(apiClient: ApiService = APIClient()) {
        self.apiClient = apiClient
    }
    
    func searchLocation<T: Decodable>(nameSufix: String, maxRows: Int, username: String) -> AnyPublisher<T, NetworkRequestError> {
        let query = ["name_startsWith": nameSufix, "maxRows": "\(maxRows)", "username": username]
        let input: RouterInput<Int> = (body: nil, query: query, pathVariables: nil)
        let route = SearchNetworkRouter.searchLocations(input)
        
        return apiClient.request(router: route)
    }
    
}

