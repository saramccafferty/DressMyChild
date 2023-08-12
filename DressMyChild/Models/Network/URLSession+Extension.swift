//
//  URLSession+Extension.swift
//  DressMyChild
//
//  Created by Sara on 23/2/2023.
//

import Foundation

extension URLSession {
    
    // function to perform data task with URLRequest object that returns a decoded result or error.
    func request<T: Codable>(
        _ request: URLRequest,
        completion: @escaping (Result<T, Error>) -> ()
    ) {
        let task = self.dataTask(with: request) { data,
            _, error in
            
            // if an error is present, return a failure result
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                // if data is returned and can be decoded return success result
                if let model = try?
                    JSONDecoder().decode(T.self, from: data) {
                    completion(.success(model))
                }
                
                print("decoding error")
                // handle the decode error here
            }
            
        }
        
        task.resume()
    }
}
