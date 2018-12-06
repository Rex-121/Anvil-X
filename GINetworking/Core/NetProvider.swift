//
//  NetProvider.swift
//  GI_Networking
//
//  Created by Ray on 2018/11/16.
//

import Moya

import Result

public typealias GITargetType = Moya.TargetType

public struct GIResult<Target: Codable>: Codable {
    public var result: Target?
    
    public let message: String?
    
    public let code: Int?
    
    public let status: String?
    
    private enum CodingKeys: String, CodingKey {
        case result = "data", code = "responseCode", message, status
    }

}

public typealias NetDone<R: Codable> = (_ result: Result<GIResult<R>, MoyaError>) -> Void

struct NoResult: Codable { }

open class NetProvider<T: GITargetType, R: Codable>: MoyaProvider<T>, GI_NetworkingSession {
    
    public override init(endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider<T>.defaultEndpointMapping,
                         requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping,
                         stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider<T>.neverStub,
                         callbackQueue: DispatchQueue? = nil,
                         manager: Manager = NetProvider<T, R>.defaultSession(),
                         plugins: [PluginType] = [],
                         trackInflights: Bool = false) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugins, trackInflights: trackInflights)
        
    }
    
    @discardableResult
    public func go(_ t: T, done: @escaping NetDone<R>) -> Cancellable {
        
        return super.request(t, completion: { (result) in
            switch result {
            case .success(let r):
                
                do {
                    let k = try JSONDecoder().decode(GIResult<R>.self, from: r.data)
                    done(Result.success(k))
                } catch {
                    done(Result.failure(MoyaError.requestMapping(error.localizedDescription)))
                }
                
                
                //                    if let new = GIResult(r.data) {
                //                        done(Result.success(new))
                //                    }
                //                    else {
                //                        done(Result.failure(MoyaError.requestMapping("unknow")))
            //                    }
            case .failure(let error):
                done(Result.failure(error))
            }
        })
    }
    
}
