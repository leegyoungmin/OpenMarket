//
//  CircularQueue.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

struct CircularQueue<T> {
    private var data: [T?]
    private var frontIndex = 0
    private var rearIndex = 0
    
    init(count: Int) {
        self.data = Array(repeating: nil, count: count)
    }
    
    private var availableSpaceForDequeue: Int {
        return rearIndex - frontIndex
    }
    
    private var availableSpaceForEnqueue: Int {
        return data.count - availableSpaceForDequeue
    }
    
    var isEmpty: Bool {
        return availableSpaceForDequeue == 0
    }
    
    var isFull: Bool {
        return availableSpaceForEnqueue == 0
    }
    
    @discardableResult
    mutating func enqueue(_ element: T, with index: Int? = nil) -> Bool {
        if let index = index, (0..<data.count) ~= index {
            let isEmptySpace = (data[index] == nil)
            data[index] = element
            
            if isFull == true || isEmptySpace == false {
                return true
            }
            rearIndex += 1
            return true
        } else {
            return false
        }
    }
    
    mutating func dequeue() -> T? {
        if isEmpty == false {
            let element = data[frontIndex % data.count]
            frontIndex += 1
            return element
        } else {
            return nil
        }
    }
    
    func flatten() -> [T] {
        return data.compactMap { $0 }
    }
}
