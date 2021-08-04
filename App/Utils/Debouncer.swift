//
//  Debouncer.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/08/01.
//

import Foundation

public class Debouncer<T: Equatable> {
    
    // MARK: - Properties
    private(set) var value: T?
    private var valueTimeStamp: Date = Date()
    private var interval: TimeInterval
    private var queue: DispatchQueue
    private var callBacks: [CallBackWithValue<T, Void>] = []
    private var debounceWorkItem: DispatchWorkItem = DispatchWorkItem {}
    
    public init(_ interval: TimeInterval, on queue: DispatchQueue = .main) {
        self.interval = interval
        self.queue = queue
    }
    
    public func on(throttled: @escaping CallBackWithValue<T, Void>) {
        callBacks.append(throttled)
    }
    
    public func receive(_ value: T) {
        self.value = value
        dispathDebounce()
    }
    
    // MARK: - Private Method
    private func dispathDebounce() {
        valueTimeStamp = Date()
        debounceWorkItem.cancel()
        debounceWorkItem = DispatchWorkItem { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.onDebounce()
        }
        queue.asyncAfter(deadline: .now() + interval, execute: debounceWorkItem)
    }
    
    private func onDebounce() {
        if Date().timeIntervalSince(valueTimeStamp) > interval {
            sendValue()
        }
    }
    
    private func sendValue() {
        guard let value = value else {
            return
        }
        callBacks.forEach { $0(value) }
    }
}
