// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let news = try? JSONDecoder().decode(News.self, from: jsonData)

import Foundation

// MARK: - News
struct News: Codable {
    let data: [Article]?
}

// MARK: - Datum
struct Article: Codable {
    let title, text: String?
    let url: String?
}
