//
//  TargetType.swift
//  Anvil
//
//  Created by Tyrant on 2020/1/11.
//

import Foundation


protocol Kx: Decodable {
    
}

protocol AnvilTargetType: TargetType {
    
    
    var resultType: Kx.Type { get }
    
//    var baseURL: URL
//
//    var path: String
//
//    var method: Method
//
//    var sampleData: Data
//
//    var task: Task
//
//    var headers: [String : String]?
//
    
}
