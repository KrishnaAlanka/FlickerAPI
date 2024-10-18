//
//  FlickerItemAccessObject.swift
//  CodeChallenge
//
//  Created by Krishna Alanka on 10/18/24.
//

import Foundation

struct FlickerItemAccessObject {
    private let flickerItem: FlickerItem
    
    init(flickerItem: FlickerItem) {
        self.flickerItem = flickerItem
    }
    
    var formattedDate: String {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: flickerItem.published) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .medium
            outputFormatter.timeStyle = .short
            return outputFormatter.string(from: date)
        }
        return flickerItem.published
    }
    
    var plainText: String {
        guard let data = flickerItem.descriptionHTML.data(using: .utf8) else {
            return ""
        }
        
        do {
            let nsAttributedString = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
            return nsAttributedString.string
        } catch {
            print("Failed to convert HTML to AttributedString: \(error)")
            return "Description not available"
        }
    }
    
    var dimensions: CGSize? {
        let widthPattern = "width=\"(\\d+)\""
        let heightPattern = "height=\"(\\d+)\""
        
        if let widthString = extractFirstMatch(for: widthPattern, in: flickerItem.descriptionHTML),
           let heightString = extractFirstMatch(for: heightPattern, in: flickerItem.descriptionHTML),
           let width = Double(widthString),
           let height = Double(heightString) {
            return CGSize(width: width, height: height)
        }
        
        return nil
    }
    
    private func extractFirstMatch(for pattern: String, in html: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: html.utf16.count)
        
        if let match = regex?.firstMatch(in: html, options: [], range: range),
           let matchRange = Range(match.range(at: 1), in: html) {
            return String(html[matchRange])
        }
        
        return nil
    }
}
