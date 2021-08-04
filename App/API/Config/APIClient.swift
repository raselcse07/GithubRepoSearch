//
//  APIClient.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/07/31.
//

import Foundation

final class APIClient: HTTPClient {
    
    static var `default`: APIClient = .init()
    
    func send<BodyType: JSONType>(_ request: HTTPRequest<BodyType>, completion: @escaping CallBackWithValue<Result<HTTPResponse<BodyType>, Error>, Void>) {
        
        do {
            let response = try send(request)
            _ = response.onSuccess { body in
                completion(.success(body))
            }
            _ = response.onError { error in
                completion(.failure(error))
            }
        } catch {
            completion(.failure(APIError.E1002))
        }
    }
    
    func send<BodyType>(_ request: HTTPRequest<BodyType>, completion: @escaping CallBackWithValue<Result<HTTPResponse<BodyType>, APIError>, Void>) {
        do {
            let response = try send(request)
            _ = response.onSuccess { body in
                completion(.success(body))
            }
            _ = response.onError { error in
                completion(.failure(error))
            }
        } catch {
            completion(.failure(APIError.E1002))
        }
    }
    
    override func commonResponseHandler<BodyType>(response: HTTPResponse<BodyType>) -> HTTPResponse<BodyType>? {

        if [200, 299].contains(response.statusCode) {
            return response
        }
        
        return nil
    }
}
