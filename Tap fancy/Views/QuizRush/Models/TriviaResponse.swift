import Foundation

struct TriviaResponse: Codable {
    let responseCode: Int
    let results: [TriviaQuestion]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

struct TokenResponse: Codable {
    let token: String
}

enum TriviaError: LocalizedError {
    case invalidURL
    case networkError
    case rateLimited
    case noResults
    case invalidParameter
    case tokenNotFound
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError:
            return "Network connection failed. Please check your internet."
        case .rateLimited:
            return "Too many requests. Please wait a moment."
        case .noResults:
            return "No trivia questions available"
        case .invalidParameter:
            return "Invalid request parameters"
        case .tokenNotFound:
            return "Session expired. Please try again."
        case .unknownError:
            return "An unknown error occurred"
        }
    }
}
