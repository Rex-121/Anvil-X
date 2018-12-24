//
//  NetProvider.swift
//  GI_Networking
//
//  Created by Ray on 2018/11/16.
//

import Moya

import Result

public typealias TargetType = Moya.TargetType

public typealias NetDone<Care: Codable> = (Result<GIResult<Care>, MoyaError>) -> Void

open class NetProvider<T: TargetType, Care: Codable>: MoyaProvider<T>, GI_NetworkingSession {
    
    public override init(endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider<T>.defaultEndpointMapping,
                         requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping,
                         stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider<T>.neverStub,
                         callbackQueue: DispatchQueue? = nil,
                         manager: Manager = NetProvider<T, Care>.defaultSession(),
                         plugins: [PluginType] = [],
                         trackInflights: Bool = false) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugins, trackInflights: trackInflights)
        
    }
    
    @discardableResult
    public func go(_ t: T, done: @escaping NetDone<Care>) -> Cancellable {
        
        return super.request(t, completion: { (result) in
            switch result {
            case .success(let r):

                do {
                    let k = try JSONDecoder().decode(GIResult<Care>.self, from: r.data)
                    
                    done(Result.success(k))
                } catch {
                    done(Result.failure(MoyaError.requestMapping(error.localizedDescription)))
                }

            case .failure(let error):
                done(Result.failure(error))
            }
        })
    }
    
}

/** 代码可用
extension Result where Value == Response, Error == MoyaError {
    func take<Care: Codable>(care: Care.Type) throws -> GIResult<Care> {
        switch self {
        case .success(let r):
            return try JSONDecoder().decode(GIResult<Care>.self, from: r.data)
        case .failure(let error): throw error
        }
    }
}
*/
