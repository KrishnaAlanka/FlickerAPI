//
//  FlickrSearchView.swift
//  CodeChallenge
//
//  Created by Krishna Alanka on 10/17/24.
//

import SwiftUI

struct FlickerSearchView: View {
    @StateObject var viewModel: FlickerSearchViewModel = FlickerSearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchQuery)
                    .accessibilitySortPriority(2)
                
                if viewModel.flickerItem.isEmpty {
                    EmptyStateView()
                        .accessibilityLabel("No results found")
                        .accessibilityHint("Please enter a different search query.")
                        .accessibilitySortPriority(1)
                    Spacer()
                } else {
                    VerticalGrid(items: viewModel.flickerItem)
                        .accessibilitySortPriority(1)
                }
            }
            .navigationTitle("Flicker search")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - VerticalGrid
struct VerticalGrid: View {
    var items: [FlickerItem]
    
    private let gridItem = [GridItem(.adaptive(minimum: 120))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItem, spacing: 8) {
                ForEach(items, id: \.id) { item in
                    NavigationLink(destination: FlickerDetailView(item: item, accessObject: FlickerItemAccessObject(flickerItem: item))) {
                        CacheImageDownloader(url: URL(string: item.media.m)!)
                            .frame(minWidth: 120, maxHeight: 120)
                            .cornerRadius(8)
                            .accessibilityLabel(item.title.isEmpty ? "Image thumbnail" : "Image: \(item.title)")
                            .accessibilityHint("Tap to view image details.")
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Image grid")
    }
}

// MARK: - SearchBar
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .accessibilityLabel("Search field")
                .accessibilityHint("Enter text to search for images")
                .accessibilityValue(text)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .accessibilityHint("magnifyingGlass Search image")
                        clearButton
                    }
                )
                .padding(.horizontal, 10)
                .font(.body)
        }
    }
    
    private var clearButton: some View {
        Button(action: {
            text = ""
        }) {
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
                .accessibilityLabel("Clear search text button")
                .accessibilityHint("Tap to clear current search query")
        }
        .opacity(text.isEmpty ? 0 : 1) // Show button only if text is not empty
    }
}


#Preview {
    FlickerSearchView()
}
