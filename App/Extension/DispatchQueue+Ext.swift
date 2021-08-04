//
//  DispatchQueue+Ext.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/08/03.
//

import Foundation

extension DispatchQueue {
    
    public static func runOnMain(delay: DispatchTimeInterval = .never, _ task: @escaping CallBack) {
        delay == .never ? main.async(execute: task) : main.asyncAfter(deadline: .now() + delay, execute: task)
    }
    
    public static func runOnGlobal(delay: DispatchTimeInterval = .never, _ task: @escaping CallBack) {
        delay == .never ? global().async(execute: task) : global().asyncAfter(deadline: .now() + delay, execute: task)
    }
}
