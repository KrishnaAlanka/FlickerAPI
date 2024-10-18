//
//  CacheImageDownloader.swift
//  CodeChallenge
//
//  Created by Krishna Alanka on 10/17/24.
//

import Foundation

import SwiftUI

struct CacheImageDownloader: View {

    @State private var image: UIImage?
    @State private var isLoading: Bool = true
    private let url: URL
    private let placeholder: Image
    private let imageSize: CGSize

    init(url: URL, placeholder: Image = Image(systemName: "photo"), size: CGSize = CGSize(width: 120, height: 120)) {
        self.url = url
        self.placeholder = placeholder
        self.imageSize = size
    }

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize.width, height: imageSize.height, alignment: .center)
            } else if isLoading {
                ProgressView()
                    .frame(width: imageSize.width, height: imageSize.height)
            } else {
                placeholder
                    .frame(width: imageSize.width, height: imageSize.height)
            }
        }
        .onAppear(perform: loadImage)
    }

    private func loadImage() {
        let cache = ImageCache.shared
        
        // Check cache first
        if let cachedImage = cache.image(for: self.url) {
            self.image = cachedImage
            self.isLoading = false // Loading finished as we have an image
            return
        }
        
        // Start loading the image
        isLoading = true
        
        Task {
            do {
                let data = try await downloadImageData(from: url)
                if let loadedImage = UIImage(data: data) {
                    self.image = loadedImage
                    ImageCache.shared.saveImage(loadedImage, url: url) // Save to cache
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            // Update loading state after attempting to load the image
            self.isLoading = false
        }
    }

    func downloadImageData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    func asUIImage() -> UIImage? {
        return image
      }
}

class ImageCache {
    static let shared = ImageCache()

    private var cache = NSCache<NSURL, UIImage>()

    private init() {}

    func image(for imageUrl: URL) -> UIImage? {
        return cache.object(forKey: imageUrl as NSURL)
    }

    func saveImage(_ image: UIImage, url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

#Preview {
    CacheImageDownloader(url: URL(string:"https://live.staticflickr.com/65535/54067558423_4469a97fb7_m.jpg")!)
}


