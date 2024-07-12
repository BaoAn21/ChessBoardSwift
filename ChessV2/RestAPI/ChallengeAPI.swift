//
//  ChallengeAPI.swift
//  ChessV2
//
//  Created by Trần Ân on 10/7/24.
//

import Foundation


struct ChallengeAPI {
    static func challengeMaiaBot(tokenId: String) {
        let urlString = "https://lichess.org/api/challenge/maia1"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(tokenId)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "rated": false,
            "clock.limit": 600,
            "clock.increment": 0,
            "keepAliveStream": false
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
//            if let response = response as? HTTPURLResponse {
//                print("Status Code: \(response.statusCode)")
//                if let data = data, let responseString = String(data: data, encoding: .utf8) {
//                    print("Response: \(responseString)")
//                }
//            }
        }
        task.resume()
        
    }
}
