//
//  FlickerSearchViewModelTests.swift
//  CodeChallengeTests
//
//  Created by Krishna Alanka on 10/17/24.
//

import Foundation
import XCTest
import Combine
@testable import CodeChallenge

final class FlickerSearchViewModelTests: XCTestCase {
    
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
        
        viewModel.$flickerItem
            .sink { items in
                if !items.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertTrue(viewModel.flickerItem.count > 0)
        XCTAssertEqual(viewModel.flickerItem.first?.title, "Simon the bashful kitty_IMG_0665")
        XCTAssertEqual(viewModel.flickerItem.first?.author, "nobody@flickr.com (\"jtakaki3\")")

        
    }

    // Test search query returns empty data
    func testSearchQueryReturnsEmptyData() {

        viewModel.searchQuery = ""
        
        let expectation = self.expectation(description: "Search returns empty data")
                
        viewModel.$flickerItem
            .sink { items in
                if items.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(viewModel.flickerItem.count == 0)
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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
