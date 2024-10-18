//
//  FlickrAPI.swift
//  CodeChallenge
//
//  Created by Krishna Alanka on 10/17/24.
//

import Foundation
import Combine

class FlickerAPI: NetworkManagerProtocol {
    private let urlSession: URLSession
    private let decoder: JSONDecoder

    init(urlSession: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    func fetchImages<T: Decodable>(url: String, type: T.Type) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: url) else {
            return Fail(error: NetworkError.URLMissing).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if error is URLError {
                    return .invalidEndpoint(reasonString: "")
                } else if error is DecodingError {
                    return .dataParsingError(reasonString: "")
                } else {
                    return .customError(reasonString: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}
