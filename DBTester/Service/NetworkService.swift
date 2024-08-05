import Foundation

class NetworkService {
        
    func performRequest(endpoint: String, requestData: [String: Any], completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData, options: [])
        } catch {
            completion(.failure(error))
            return
        }
                 
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                // Assuming the response data is JSON and can be cast to [String: Any]
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(NSError(domain: "Invalid JSON data", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func performRequest(method: String, endpoint: String, body: [String: Any]?) async throws -> [String: Any] {
        guard let url = URL(string: endpoint) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw NSError(domain: "Invalid JSON data", code: 0, userInfo: nil)
        }
        
        return json
    }
}
