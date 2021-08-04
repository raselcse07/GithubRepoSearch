//
//  HTTPClient.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/07/31.
//

import Foundation

open class HTTPClient {
    
    open var timeoutIntervalForRequest: TimeInterval = 30.0
    open var timeoutIntervalForResource: TimeInterval = 60.0
    
    open var config: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        config.timeoutIntervalForRequest = timeoutIntervalForRequest
        config.timeoutIntervalForResource = timeoutIntervalForResource
        return config
    }
    
    open var session: URLSession {
        return URLSession(configuration: config)
    }
    
    public init() {}
    
    public func send<BodyType: JSONType>(_ request: HTTPRequest<BodyType>) throws -> HTTPTask<BodyType> {
        return try createJSONTask(request).execute()
    }
    
    public func send<BodyType>(_ request: HTTPRequest<BodyType>) throws -> HTTPTask<BodyType> {
        return try createTask(request).execute()
    }
    
    public func commonResponseHandler<BodyType>(response: HTTPResponse<BodyType>) -> HTTPResponse<BodyType>? {
        return response
    }

    
}

// MARK: - Task Create
extension HTTPClient {
    
    fileprivate func createTask<BodyType>(_ request: HTTPRequest<BodyType>) throws -> HTTPTask<BodyType> {
       
        guard let req = parseRequest(request) else {
            throw APIError.E1001
        }
        
        let task = HTTPTask<BodyType>(request: req, session: session)
        task.commonResponseHandler = commonResponseHandler
        
        return task
    }
    
    fileprivate func createJSONTask<BodyType: JSONType>(_ request: HTTPRequest<BodyType>) throws -> HTTPTask<BodyType> {
        
        guard let req = parseRequest(request) else {
            throw APIError.E1001
        }
        
        let task = JSONTask<BodyType>(request: req, session: session)
        task.commonResponseHandler = commonResponseHandler
        return task
    }
    
    fileprivate func parseRequest<BodyType>(_ request: HTTPRequest<BodyType>) -> URLRequest? {
        
        guard let url = request.url else {
            return nil
        }
        // create url request
        var urlRequest = URLRequest(url: url)
        // set method
        urlRequest.httpMethod = request.method.rawValue
        // set headers
        request.headers.forEach { value in
            let (key, val) = value
            urlRequest.addValue(val, forHTTPHeaderField: key)
        }
        // set body
        if request.isJSONRequest {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: request.parameters, options: [.prettyPrinted])
            } catch {
                return nil
            }
        } else {
            let parameterArray = request.parameters.map { (arg) -> String in
                let (key, val) = arg
                return "\(key)=\(val)"
            }
            urlRequest.httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
        }
        return urlRequest
    }
}
