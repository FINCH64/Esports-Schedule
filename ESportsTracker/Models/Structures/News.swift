import Foundation

//структура того как будет выглядеть объект новости описана в этом файле

// MARK: - News
struct News: Codable {
    let data: [Article]?
}

// MARK: - Datum
struct Article: Codable {
    let title, text: String?
    let url: String?
}
