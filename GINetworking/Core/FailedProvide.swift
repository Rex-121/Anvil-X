//
//  FailedProvide.swift
//  Alamofire
//
//  Created by Tyrant on 2019/5/23.
//

import Foundation

public struct Failable<Value : Decodable> : Decodable {
    
    public let value: Value?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self.value = try container.decode(Value.self)
        }
        catch {
            print(error)
            self.value = nil
        }
    }
}

extension Collection {
    
    public func value<Value>() -> [Value] where Value: Decodable, Element == Failable<Value> {
        return self.compactMap { $0.value }
    }
    
}
