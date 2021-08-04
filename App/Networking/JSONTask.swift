//
//  JSONTask.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/07/31.
//

import Foundation

class JSONTask<BodyType: JSONType>: HTTPTask<BodyType> {
    
    override func pareseBody(_ data: Data) -> BodyType? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(BodyType.self, from: data)
        } catch {
            return nil 
        }
    }
}
