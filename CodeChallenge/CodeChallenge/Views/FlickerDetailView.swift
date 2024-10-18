//
//  FlickerDetailView.swift
//  CodeChallenge
//
//  Created by Krishna Alanka on 10/17/24.
//

import SwiftUI

struct FlickerDetailView: View {
    let item: FlickerItem
    let accessObject: FlickerItemAccessObject
    
    var body: some View {
        ScrollView(.vertical) {
            VStack() {
                CacheImageDownloader(url: URL(string: item.media.m)!, size: CGSize(width: 300, height: 400))
                    .accessibilityLabel("Image")
                
                MetadataGroup(item: item, accessObject: accessObject)
                
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .navigationTitle(item.title.isEmpty ? "Image Details" : item.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                let imageURL = URL(string: item.media.m) ?? URL(string: "https://www.flickr.com")!
                ShareLink(
                    item: createShareContent(),
                    subject: Text("Check out this image from Flickr"),
                    message: Text("Title: \(item.title)\nAuthor: \(item.author)\nPublished Date: \(accessObject.formattedDate)"),
                    preview: SharePreview(item.title, image: imageURL)
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .accessibilityLabel("Share this image")
                }
            }
        }
    }
    
    private func createShareContent() -> URL {
        // Share the image URL
        return URL(string: item.media.m) ?? URL(string: "https://www.flickr.com")!
    }
    
}

struct MetadataGroup: View {
    let item: FlickerItem
    let accessObject: FlickerItemAccessObject

    var body: some View {
        GroupBox(label: Text("Metadata").fontWeight(.semibold)) {
            Divider()
            MetadataDivider(label: "Title:", value: item.title, attributedValue: nil)
            MetadataDivider(label: "Description:", value: accessObject.plainText.description, attributedValue: accessObject.plainText)
            MetadataDivider(label: "Author:", value: item.author, attributedValue: nil)
            let width = accessObject.dimensions?.width
            let height = accessObject.dimensions?.height
            MetadataDivider(label: "Size:", value: "\(width ?? 0.0) X \(height ?? 0.0)", attributedValue: nil)
            MetadataDivider(label: "Published Date:", value: accessObject.formattedDate, attributedValue: nil)
        }
    }
}

struct MetadataDivider: View {
    let label: String
    let value: String?
    let attributedValue: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .accessibilityLabel(label)
            if let attributedDescription = attributedValue {
                Text(attributedDescription)
                    .font(.caption2)
                    .foregroundStyle(.primary)
                    .accessibilityLabel(attributedDescription)
            } else {
                Text(value ?? "")
                    .font(.caption2)
                    .foregroundStyle(.primary)
                    .accessibilityLabel(value ?? "")
            }
            Divider()
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    let testItem = FlickerItem(
            title: "Test",
            link: "link",
            dateTaken: nil,
            descriptionHTML: "",
            published: "",
            author: "",
            authorID: "",
            tags: "",
            media: FlickerMedia(m: "https://example.com/image.jpg")
        )
        let testAccessObject = FlickerItemAccessObject(flickerItem: testItem)

        return FlickerDetailView(item: testItem, accessObject: testAccessObject)

}
