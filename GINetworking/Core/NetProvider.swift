//
//  NetProvider.swift
//  GI_Networking
//
//  Created by Ray on 2018/11/16.
//

import Moya

import enum Result.Result
import ReactiveSwift
public typealias TargetType = Moya.TargetType

//public typealias NetDone<Care: Codable> = (Result<GIResult<Care>, MoyaError>) -> Void

open class NetProvider<T: TargetType>: MoyaProvider<T>, GI_NetworkingSession {
    
    public override init(endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider<T>.defaultEndpointMapping,
                         requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping,
                         stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider<T>.neverStub,
                         callbackQueue: DispatchQueue? = nil,
                         manager: Manager = NetProvider<T>.defaultSession(),
                         plugins: [PluginType] = [],
                         trackInflights: Bool = false) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugins, trackInflights: trackInflights)
        
    }
    
    open func go<Care: Codable>(_ target: T, _ codable: Care.Type) -> SignalProducer<GIResult<Care>, MoyaError> {
        return super.reactive.request(target).map({ (response) -> GIResult<Care> in
            do {
                return try JSONDecoder().decode(GIResult<Care>.self, from: response.data)
            } catch {
                return GIResult.ParseWrong
            }
        })
    }
    
    open func launch<Care: Codable>(_ target: T, _ codable: Care.Type) -> SignalProducer<GIResult<Care>, GINetError> {
        return super.reactive.request(target)
            .map({ (response) -> GIResult<Care> in
                do {
                    return try JSONDecoder().decode(GIResult<Care>.self, from: response.data)
                } catch {
                    return GIResult.ParseWrong
                }
            })
            .mapError({ (moyaError) -> GINetError in
                return GINetError.network(moyaError.localizedDescription, moyaError.response)
            })
            .attempt({ (result) -> Result<(), GINetError> in
                if result.good { return Result(()) }
                return Result(error: GINetError.business(GINetError.Info(code: result.code, message: result.message)))
            })
    }
    
    open func launch(_ target: T) -> SignalProducer<GIResult<DontCare>, GINetError> {
        return self.launch(target, DontCare.self)
    }
    
    public func go(_ target: T) -> SignalProducer<GIResult<DontCare>, MoyaError> {
        return self.go(target, DontCare.self)
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
