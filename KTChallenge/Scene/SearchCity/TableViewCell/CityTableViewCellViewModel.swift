//
//  CityTableViewCellViewModel.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//

import Combine
protocol CityTableViewCellViewModelType {
    var cityName: AnyPublisher<String?, Never> { get }
    var stateName: AnyPublisher<String?, Never>{ get }
    var countryName: AnyPublisher<String?, Never> { get }
}

class CityTableViewCellViewModel: CityTableViewCellViewModelType {
    
    private let cityNameSubject: CurrentValueSubject<String?, Never>
    private let  stateNameSubject: CurrentValueSubject<String?, Never>
    private let  countryNameSubject: CurrentValueSubject<String?, Never>
    
    //MARK:- outputs
    var cityName: AnyPublisher<String?, Never> { cityNameSubject.eraseToAnyPublisher() }
    var stateName: AnyPublisher<String?, Never>{ stateNameSubject.eraseToAnyPublisher() }
    var countryName: AnyPublisher<String?, Never> { countryNameSubject.eraseToAnyPublisher() }
    
    
    init(_ city: CityType) {
        cityNameSubject = CurrentValueSubject(city.name)
        stateNameSubject = CurrentValueSubject(city.state)
        countryNameSubject = CurrentValueSubject(city.country)
    }
}



