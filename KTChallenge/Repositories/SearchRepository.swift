//
//  SearchRepository.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//

import Combine
protocol SearchRepositoryType {
    func searchCity(nameSufix: String, maxRows: Int, username: String) -> AnyPublisher<Cities, NetworkRequestError>
}

class SearchRepository: BaseRepository, SearchRepositoryType {
    func searchCity(nameSufix: String, maxRows: Int, username: String) -> AnyPublisher<Cities, NetworkRequestError> {
        searchService.searchLocation(nameSufix: nameSufix, maxRows: maxRows, username: username)
    }
}

class MockSearchRepository: SearchRepositoryType {
    func searchCity(nameSufix: String, maxRows: Int, username: String) -> AnyPublisher<Cities, NetworkRequestError> {
        return Result.Publisher(Cities(totalResultsCount: 1, geonames: City.mocked))
            .eraseToAnyPublisher()
    }
}
