//
//  URLRequest+Extension.swift
//  DressMyChild
//
//  Created by Sara on 23/2/2023.
//

import Foundation

extension URLRequest {
    // initializer takes a url string and a dictionary of queries as parameters
    init(url: String, queries: [String: String]) {
        // create a URLComponents object with the provided url and set the query items from the queries dictionary
        var components = URLComponents(
            url: URL(string: url)!,
            resolvingAgainstBaseURL: true)!
        
        components.queryItems = queries
            .map { URLQueryItem(name: $0.key, value: $0.value)
            }
        
        // initialize the URLRequest object with the url from the URLComponents object
        self.init(url: components.url!)
    }
}
