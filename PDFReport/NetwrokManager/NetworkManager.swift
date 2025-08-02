//
//  NetworkManager.swift
//  PDFReport
//
//  Created by Divyanshu Jadon on 02/08/25.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private let session = URLSession(configuration: .default)
    private init() {}

    private let cache = NSCache<NSString, CacheEntry>()
    private let isLoggingEnabled = true

    /// Generic wrapper to hold cached decoded values
    private class CacheEntry {
        let value: Any
        init(_ value: Any) {
            self.value = value
        }
    }

    func request<T: Decodable>(
        urlString: String,
        method: String = "GET",
        headers: [String: String]? = nil,
        body: Data? = nil,
        useCache: Bool = true,
        cacheExpiry: TimeInterval = 60 * 5, // 5 min
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            return completion(.failure(.invalidURL))
        }

        let cacheKey = makeCacheKey(urlString: urlString, method: method, body: body)

        if useCache, let cached = cache.object(forKey: cacheKey), let value = cached.value as? T {
            if isLoggingEnabled { print("✅ Returning cached result for \(urlString)") }
            return completion(.success(value))
        }

        if !Reachability.isConnectedToNetwork() {
            return completion(.failure(.offline))
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = body

        logRequest(request, body: body)

        session.dataTask(with: request) { data, response, error in
            self.logResponse(data, response, error)

            if let err = error {
                return completion(.failure(.serverError(err.localizedDescription)))
            }

            guard let data = data else {
                return completion(.failure(.noData))
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                self.cache.setObject(CacheEntry(decoded), forKey: cacheKey)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }

    private func makeCacheKey(urlString: String, method: String, body: Data?) -> NSString {
        var identifier = "\(method.uppercased())-\(urlString)"
        if let body = body {
            identifier += "-\(body.hashValue)"
        }
        return NSString(string: identifier)
    }

    private func logRequest(_ request: URLRequest, body: Data?) {
        guard isLoggingEnabled else { return }
        print("\n📤 REQUEST:")
        print("URL: \(request.url?.absoluteString ?? "")")
        print("Method: \(request.httpMethod ?? "")")
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        if let body = body,
           let json = try? JSONSerialization.jsonObject(with: body, options: .mutableContainers) {
            print("Body: \(json)")
        }
    }

    private func logResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        guard isLoggingEnabled else { return }
        print("\n📥 RESPONSE:")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
        }
        if let data = data,
           let jsonString = String(data: data, encoding: .utf8) {
            print("Response Body: \(jsonString)")
        }
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
    }
}


enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingFailed
    case serverError(String)
    case offline

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .noData: return "No data received from server."
        case .decodingFailed: return "Failed to decode response."
        case .serverError(let message): return message
        case .offline: return "No internet connection."
        }
    }
}

