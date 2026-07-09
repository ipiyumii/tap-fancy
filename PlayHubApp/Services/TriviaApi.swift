
import Foundation

struct TriviaAPI {
    private static var sessionToken: String?
    
    static func fetchQuestions() async throws -> [TriviaQuestion] {
        var urlString = "https://opentdb.com/api.php?amount=10&type=multiple"
        
        if let token = sessionToken {
            urlString += "&token=\(token)"
        }
        
        guard let url = URL(string: urlString) else {
            throw TriviaError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw TriviaError.networkError
            }
            
            if httpResponse.statusCode == 429 {
                throw TriviaError.rateLimited
            }
            
            let triviaResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)
            
            switch triviaResponse.responseCode {
            case 0:
                return triviaResponse.results
            case 1:
                throw TriviaError.noResults
            case 2:
                throw TriviaError.invalidParameter
            case 3:
                sessionToken = nil
                throw TriviaError.tokenNotFound
            case 4:
                try await requestNewToken()
                return try await fetchQuestions()
            default:
                throw TriviaError.unknownError
            }
        } catch {
            throw error
        }
    }
    
    static func requestNewToken() async throws {
        let urlString = "https://opentdb.com/api_token.php?command=request"
        guard let url = URL(string: urlString) else {
            throw TriviaError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        sessionToken = tokenResponse.token
    }
}
