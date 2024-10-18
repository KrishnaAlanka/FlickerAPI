//
//  NetworkManager.swift
//  CodeChallenge
//
//  Created by Krishna Alanka on 10/17/24.
//

import Foundation
import Combine


enum NetworkError: Error {
    case URLMissing
    case networkError(reasonString: String)
    case dataParsingError(reasonString: String)
    case unauthorizedAccess(reasonString: String)
    case customError(reasonString: String)
    case invalidEndpoint(reasonString: String)

    var errorDiscription: String {
        switch self {
        case .URLMissing:
            return "URL is Missing"
        case .networkError(reasonString: let reasonString),
                .dataParsingError(reasonString: let reasonString),
                .customError(reasonString: let reasonString),
                .unauthorizedAccess(reasonString: let reasonString),
            .invalidEndpoint(reasonString: let reasonString):
            return reasonString
        }
    }
}

protocol FlickerServiceAPIProtocol {
    func fetchFlickerData(for queryString: String) -> AnyPublisher<FlickerModel, NetworkError>
}
protocol NetworkManagerProtocol {
    func fetchImages<T: Decodable>(url: String, type: T.Type) -> AnyPublisher<T, NetworkError>
}

class NetworkManager: FlickerServiceAPIProtocol {
    
    private let flickerApi: NetworkManagerProtocol

    init(api: NetworkManagerProtocol) {
        self.flickerApi = api
    }
    
    func fetchFlickerData(for queryString: String) -> AnyPublisher<FlickerModel, NetworkError> {
        self.flickerApi.fetchImages(url: "\(Constants.API.url)\(queryString)", type: FlickerModel.self)
    }
}
