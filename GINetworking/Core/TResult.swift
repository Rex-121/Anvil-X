//
//  TResult.swift
//  GINetworking
//
//  Created by Ray on 2018/12/6.
//

import Moya

public typealias MFData = Moya.MultipartFormData
extension Dictionary where Value == String, Key == String {
    public func multipartData() -> [MFData] { return self.map { MultipartFormData(provider: .data($1.data(using: .utf8)!), name: $0) } }
}

public struct DontCare: Codable { }

public struct GIResult<Care: Codable>: Codable {
    
    /// 解析的结构
    public var result: Care?
    
    ///信息
    public let message: String?
    
    ///请求码
    public let code: Int?
    
    ///请求状态
    public let status: String?
    
    private enum CodingKeys: String, CodingKey {
        case result = "data", code = "responseCode", message, status
    }
    
}

extension GIResult {
    static var ParseWrong: GIResult {
        return GIResult(result: nil, message: "解析错误", code: -999, status: "")
    }
}

//extension GIResult {
//    
//    /// (解析的结构，请求信息)
//    var truck: (Care?, GIResult) {
//        return (self.result, self)
//    }
//}

//public enum XResult: Codable {
//
//    case success
//
//    case failure
//
//    struct Keys: CodingKey {
//        var stringValue: String
//        init?(stringValue: String) {
//            self.stringValue = stringValue
//        }
//
//        var intValue: Int? { return nil }
//        init?(intValue: Int) { return nil }
//
//        static let message = Keys(stringValue: "message")!
//        static let code = Keys(stringValue: "responseCode")!
//        static let data = Keys(stringValue: "data")!
//        static let status = Keys(stringValue: "status")!
//    }
//
//
//    public init(from decoder: Decoder) throws {
//        do {
//           let k = try decoder.container(keyedBy: Keys.self)
//
//            let m = try k.decode(String.self, forKey: .message)
//
//            print(m)
//
////            for key in k.allKeys {
////                print(key)
//////                let productContainer = try k.nestedContainer(keyedBy: ProductKey.self, forKey: key)
////                let p = try productContainer.decode(Int.self, forKey: .code)
////                print(p)
////            }
//
//            self = .success
//        } catch {
//            self = .failure
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws { }
//}
//

