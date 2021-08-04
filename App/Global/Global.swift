//
//  Global.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/07/31.
//

import Foundation

public protocol JSONType: Decodable {}
public typealias CallBackWithValue<Input, Output> = (Input) -> Output
public typealias CallBack = () -> Void
