//
//  FlickrViewModel.swift
//  CodeChallenge
//
//  Created by Krishna Alanka on 10/17/24.
//

import Foundation

import Combine

class FlickerSearchViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var isLoading = false
    @Published var flickerItem: [FlickerItem] = []
    @Published var errorMessage: String? = nil
    
    var flickerAccessItems: [FlickerItemAccessObject] {
        flickerItem.map { FlickerItemAccessObject(flickerItem: $0) }
    }

    private var cancellables = Set<AnyCancellable>()
    private var searchService: FlickerServiceAPIProtocol
    
    init(searchService: FlickerServiceAPIProtocol = NetworkManager(api: FlickerAPI())) {
        self.searchService = searchService
        setupSearch()
    }
    
    private func setupSearch() {
        // Observe search query changes and debounce
        $searchQuery
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { query in
                query
                    .components(separatedBy: .whitespacesAndNewlines) // Split by whitespace and newlines
                    .filter { !$0.isEmpty } // Remove empty components
                    .joined(separator: ",") // Join with commas
            }
            .filter {
                if $0.isEmpty {
                    self.flickerItem.removeAll()
                    self.isLoading = false
                    return false
                }
                return true
            } // Filter out empty queries after transformation
            .flatMap { query -> AnyPublisher<FlickerModel, Never> in
                self.isLoading = true
                return self.searchService.fetchFlickerData(for: query)
                    .catch { error -> Just<FlickerModel> in
                            self.isLoading = false
                            self.errorMessage = "Failed to fetch results. Please try again."
                        return Just(FlickerModel(title: "", link: "", description: "", modified: "", generator: "", items: []))
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.flickerItem = results.items
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
}

