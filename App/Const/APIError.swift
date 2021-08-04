//
//  APIError.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/08/01.
//

import Foundation

struct APIError: Error {
    
    static let E1000 = APIError(code: "E1000", description: "Response error!")
    static let E1001 = APIError(code: "E1001", description: "Failed to parse request.")
    static let E1002 = APIError(code: "E1002", description: "Request error.")
    static let E1003 = APIError(code: "E1003", description: "Rate limit error.")
    static let E1004 = APIError(code: "E1004", description: "Falied to cast.")
    
    var code: String
    var description: String
    
    func formatted(_ args: CVarArg...) -> String {
        String(format: description + "（" + code + "）", arguments: args)
    }
    
    func formatted(_ args: [CVarArg]) -> String {
        String(format: description + "（" + code + "）", arguments: args)
    }
    
    func descriptionAndCode() -> String {
        description + "（" + code + "）"
    }
    
    static func convert(from error: Error) -> Self {
        guard let err = error as? Self else {
            return .E1004
        }
        return err
    }
}

extension APIError: Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        lhs.code == rhs.code
    }
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        return description
    }
}
