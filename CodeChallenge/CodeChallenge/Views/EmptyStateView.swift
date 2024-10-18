//
//  EmptyStateView.swift
//  CodeChallenge
//
//  Created by Krishna Alanka on 10/17/24.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "photo.on.rectangle.angled") // Placeholder image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .padding()
                .accessibilityHidden(true)

            Text("No images found")
                .font(.headline)
                .foregroundColor(.gray)

            Text("Try searching for something else.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .accessibilityLabel("Try searching for a different term")
        }
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("No images found")
        .accessibilityHint("Search for images using the search bar above.")
    }
}

#Preview {
    EmptyStateView()
}
