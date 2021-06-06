//
//  APIClient.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//

import Foundation
import Combine

struct ProductionServer {
    static var host = "https://api.geonames.org"
    
   static var BaseURL: URL = {
        let urlString = host
        if  let url = URL(string: urlString) {
            return url
        } else {
            fatalError("URL not found.")
        }
    }()
}

class APIClient {
    private let session = URLSession(configuration: .default)
    private func execute(request : URLRequest?) -> AnyPublisher<Data, NetworkRequestError> {
        
        guard let urlRequest = request else {
            return Fail(error: NetworkRequestError.requestError)
                .eraseToAnyPublisher()
        }
       
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw NetworkRequestError.unknown
                }
                return data
            }
            .mapError { error in
                if let error = error as? NetworkRequestError {
                    return error
                } else {
                    return NetworkRequestError.serverError(error: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}


protocol ApiService {
    func request<T: Decodable>(router: URLRequestConvertible) -> AnyPublisher<T, NetworkRequestError>
}

extension APIClient:ApiService {
    func request<T: Decodable>(router: URLRequestConvertible) -> AnyPublisher<T, NetworkRequestError> {
        
        guard Reachability.isConnectedToNetwork()  else {
            return Fail(error: NetworkRequestError.notConnected)
                .eraseToAnyPublisher()
        }
            
            let urlRequest = try? router.urlRequest()
            return  self.execute(request: urlRequest)
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error in
                    if let error = error as? NetworkRequestError {
                        return error
                    } else {
                        return NetworkRequestError.serverError(error: error.localizedDescription)
                    }
                }
                .eraseToAnyPublisher()
        }
    
}
