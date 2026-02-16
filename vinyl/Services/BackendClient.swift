import Foundation

struct BackendClient {
    enum BackendError: Error {
        case invalidUrl
        case invalidResponse
    }

    func postJson<T: Decodable>(_ path: String, body: [String: Any]) async throws -> T {
        let resolvedUrlString = path.hasPrefix("http") ? path : AppConfig.functionsBaseUrl + path
        guard let url = URL(string: resolvedUrlString) else {
            throw BackendError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw BackendError.invalidResponse
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
