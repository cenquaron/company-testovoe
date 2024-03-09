import Foundation

struct APIResponce: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let created_at: String
    let description: String?
    let urls: URLS
}

struct URLS: Codable {
    let full: String
    let regular: String
}
