//
//  FlickerSearchViewModelTest.swift
//  CodeChallengeTests
//
//  Created by Krishna Alanka on 10/17/24.
//

import Foundation
import XCTest
import Combine
@testable import CodeChallenge

final class FlickerSearchViewModelTest: XCTestCase {
    
    var viewModel: FlickerSearchViewModel!
    var mockService: MockFlickerSearchervice!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockFlickerSearchervice()
        viewModel = FlickerSearchViewModel(searchService: mockService)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // Test search query returns data successfully
    func testSearchQueryReturnsData() {

        viewModel.searchQuery = "car"
        let expectation = self.expectation(description: "Search returns data")
        
        viewModel.$pixs
            .sink { items in
                if !items.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertTrue(viewModel.pixs.count > 0)
        XCTAssertEqual(viewModel.pixs.first?.title, "Simon the bashful kitty_IMG_0665")
        XCTAssertEqual(viewModel.pixs.first?.author, "nobody@flickr.com (\"jtakaki3\")")

        
    }

    // Test search query returns empty data
    func testSearchQueryReturnsEmptyData() {

        viewModel.searchQuery = ""
        
        let expectation = self.expectation(description: "Search returns empty data")
                
        viewModel.$pixs
            .sink { items in
                if items.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(viewModel.pixs.count == 0)
    }


    // Test isLoading is updated correctly
    func testIsLoadingUpdatesCorrectly() {
        
        viewModel.searchQuery = "LoadingTest"
        
        let expectation = self.expectation(description: "isLoading is set correctly")
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                // Assert
                if isLoading {
                    XCTAssertTrue(isLoading) // Ensure loading state is true at the start
                } else {
                    XCTAssertFalse(isLoading) // Ensure loading state is false after data is fetched
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
