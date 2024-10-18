//
//  MockFlickerSearchervice.swift
//  CodeChallengeTests
//
//  Created by Krishna Alanka on 10/17/24.
//

import Foundation

import Foundation
import Combine
@testable import CodeChallenge

class MockFlickerSearchervice: FlickerServiceAPIProtocol {
    var shouldReturnError = false
    func fetchFlickerData(for queryString: String) -> AnyPublisher<FlickerModel, NetworkError> {
        if shouldReturnError {
            return Fail(error: NetworkError.invalidEndpoint(reasonString: "Invalid endpoint"))
                .eraseToAnyPublisher()
        } else {
            let response = MockFlickerSearchData.getFlickerSearchMockData()!
            return Just(response)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
    }
}

class MockFlickerSearchData: NSObject {
    
    class func getFlickerSearchMockData() -> FlickerModel? {
        let data = loadtestDataFromFile(for: "Test")
        return decodeJsonData(data: data, type: FlickerModel.self) ?? nil
    }
    
    class func loadtestDataFromFile(for fileName: String) -> Data {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return Data()
        }
        return data
    }
    class func decodeJsonData<T:Decodable>(data: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        do {
            let result = try decoder.decode(T.self, from: data)
            return result
            
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
            
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            
        } catch {
            print("reason: Failed to convert data to JSON")
        }
        return nil
    }
}
