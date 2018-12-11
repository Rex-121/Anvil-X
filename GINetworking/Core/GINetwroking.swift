//
//  GINetwroking.swift
//  GI_Networking
//
//  Created by Ray on 2018/11/15.
//

import Moya

//public typealias NetDone = (_ result: Any) -> Void

public enum NetBusiness {
    case validate(String, String), issueCoin, login(String, String), appVersion
}



public extension TargetType {
    var baseURL: URL { return URL(string: "https://www.6xhtt.com/app/api")! }
    var headers: [String : String]? { return nil }
}

extension NetBusiness: TargetType {
    public var path: String {
        switch self {
        case .validate(_, _): return "/user/loginValidate"
        case .issueCoin: return "/newc2c/issuedCoin"
        case .login(_, _): return "/user/login"
        case .appVersion: return "/index/getAppVersion"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .validate(_, _), .login(_, _), .appVersion: return .post
        case .issueCoin: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
            
        case .validate(let n, let p): return .uploadMultipart(["username":n, "password":p].multipartData())
        case .issueCoin:              return .requestPlain
        case .login(let n, let p):    return .uploadMultipart(["username":n, "password":p].multipartData())
        case .appVersion:             return .requestPlain
        }
    }
    
}

public typealias MFData = Moya.MultipartFormData
extension Dictionary where Value == String, Key == String {
    public func multipartData() -> [MFData] { return self.map { MultipartFormData(provider: .data($1.data(using: .utf8)!), name: $0) } }
}
