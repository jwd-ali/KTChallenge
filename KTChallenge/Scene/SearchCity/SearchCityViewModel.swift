//
//  SearchCityViewModel.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//
import UIKit
import Combine

typealias CitiesTableViewDiffableDataSource = UITableViewDiffableDataSource<Section, City>

enum Section {
    case main
}

protocol SearchCityViewModelType {
    var action: PassthroughSubject<String, Never> { get }
    var diffableDataSource: CitiesTableViewDiffableDataSource? { get set }
    var isLoading: AnyPublisher<Bool, Never> { get }
    var title: AnyPublisher<String?, Never> { get }
}

class SearchCityViewModel: SearchCityViewModelType {
    private let repository: SearchRepositoryType
    private var subscriptions = Set<AnyCancellable>()
    private let userName = "keep_truckin"
    private let maxRows = 10
    
    //Diffable datasource
    private let citiesSubject = PassthroughSubject<[City], NetworkRequestError>()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, City>()
    
    // Subjects
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let titleSubject = CurrentValueSubject<String?, Never>("Search")
    
    var action = PassthroughSubject<String, Never>()
    var diffableDataSource: CitiesTableViewDiffableDataSource?
    
    
    //MARK:- Outputs
    var isLoading: AnyPublisher<Bool, Never> { isLoadingSubject.eraseToAnyPublisher() }
    var title: AnyPublisher<String?, Never> { titleSubject.eraseToAnyPublisher() }
    
    
    init(repository: SearchRepositoryType) {
        self.repository = repository
        
        action.sink(receiveValue: { [weak self] search in
            self?.searchCities(with: search)
        }).store(in: &subscriptions)
    }
}

private extension SearchCityViewModel {
    func searchCities(with searchstring: String) {
        isLoadingSubject.send(true)
        
        repository.searchCity(nameSufix: searchstring, maxRows: maxRows, username: userName).receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] _ in  self?.isLoadingSubject.send(false) } )
            .sink(receiveCompletion: { error in
                if case let .failure(error) = error {
                    print(error.localizedDescription)
                        // TODO: handle error case
                }
            }) { [unowned self](cities) in
                self.snapshot.deleteAllItems()
                self.snapshot.appendSections([.main])
                self.snapshot.appendItems(cities.geonames)
                self.diffableDataSource?.apply(self.snapshot, animatingDifferences: false)
            }.store(in: &subscriptions)
    }
}
