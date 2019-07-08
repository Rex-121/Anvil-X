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

public struct GIResult<Care: Decodable>: Decodable {
    
    /// 解析的结构
    public var result: Care?
    
    ///信息
    public let message: String?
    
    ///请求码
    public let code: Int?
    
    public let good: Bool
    
    private enum CodingKeys: String, CodingKey {
        case result = "data", code, message, good = "success"
    }
    
    /// 是否成功，后台信息
    public var info: BasicInfo {
        return BasicInfo(success: good, message: message, code: code)
    }

    /// 可能的错误信息　
    public var errorInfo: GINetError {
        return .business(info)
    }
    
    public init(result: Care?, message: String?, code: Int?, good: Bool) {
        self.result = result
        self.message = message
        self.code = code
        self.good = good
    }
    
   
    
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        good = try container.decode(Bool.self, forKey: .good)
        
        message = try container.decodeIfPresent(String.self, forKey: .message)
        
        code = try container.decodeIfPresent(Int.self, forKey: .code)
        
        if !good {
            throw ReError(message: message, code: code)
        }
        
        result = try container.decodeIfPresent(Care.self, forKey: .result)
        
        
        
    }
}

struct ReError: Error {
    let message: String?
    let code: Int?
}

public struct BasicInfo: CustomStringConvertible {
    /// 是否成功
    public let success: Bool
    
    /// 信息
    public let message: String?
    
    /// 状态码
    public let code: Int?
    
    public var description: String {
        return message ?? ""
    }
}

extension GIResult {
    public static var ParseWrong: GIResult {
        return GIResult(result: nil, message: "解析错误", code: -999, good: false)
    }
    
    public static var NotFound: GIResult {
        return GIResult(result: nil, message: "无法连接到服务器", code: 404, good: false)
    }
}


public enum GINetError: Error, CustomStringConvertible {
    case business(BasicInfo), network(String, Response?)
    
    
    /// 解析错误
    public static var ParseWrong: GINetError {
        return .business(BasicInfo(success: false, message: "解析错误", code: -999))
    }
    
    
    /// 快速创建业务错误
    ///
    /// - Parameters:
    ///   - business: 错误信息
    ///   - success: 是否成功 默认为 false
    ///   - code: 错误码 默认为 -1740
    /// - Returns: 业务错误
    public static func at<B: CustomStringConvertible>(business: B?, _ success: Bool = false, _ code: Int = -1740) -> GINetError {
        return .business(BasicInfo(success: success, message: business?.description, code: code))
    }

    /// 原始的信息
    private var message: String? {
        switch self {
        case .business(let info): return info.message
        case .network(let info, _): return info
        }
    }

    /// 错误信息
    public var description: String {
        return message ?? ""
    }
    
}

