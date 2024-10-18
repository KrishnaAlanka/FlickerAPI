//
//  FlickrModel.swift
//  CodeChallenge
//
//  Created by Krishna Alanka on 10/17/24.
//

import Foundation

struct FlickerModel: Codable {
    let title: String
    let link: String
    let description: String
    let modified: String
    let generator: String
    let items: [FlickerItem]
}

struct FlickerItem: Codable, Identifiable {
    let id: UUID = UUID()
    let title: String
    let link: String
    let dateTaken: String?
    let descriptionHTML: String
    let published: String
    let author: String
    let authorID: String
    let tags: String
    let media: FlickerMedia
    
    enum CodingKeys: String, CodingKey {
        case title
        case media
        case link
        case dateTaken = "date_taken"
        case descriptionHTML = "description"
        case published
        case author
        case authorID = "author_id"
        case tags
    }
}

struct FlickerMedia: Codable {
    let m: String
}
