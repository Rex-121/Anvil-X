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
    
    open func go<Engine: Codable>(_ target: T, _ codable: Engine.Type) -> SignalProducer<GIResult<Engine>, MoyaError> {
        return super.reactive.request(target).map({ (response) -> GIResult<Engine> in
            do {
                return try JSONDecoder().decode(GIResult<Engine>.self, from: response.data)
            } catch {
                return GIResult.ParseWrong
            }
        })
    }
    
    open func launch<Engine: Codable>(_ target: T, _ codable: Engine.Type) -> SignalProducer<GIResult<Engine>, GINetError> {
        return super.reactive.request(target)
            .map({ (response) -> GIResult<Engine> in
                do {
                    return try JSONDecoder().decode(GIResult<Engine>.self, from: response.data)
                } catch {
                    return GIResult.ParseWrong
                }
            }).parachute().land()
//            .mapError({ (moyaError) -> GINetError in
//                return GINetError.network(moyaError.localizedDescription, moyaError.response)
//            })
//            .attempt({ (result) -> Result<(), GINetError> in
//                if result.good { return Result(()) }
//                return Result(error: GINetError.business(GINetError.Info(code: result.code, message: result.message)))
//            })
    }
    
    open func detach<Engine: Codable>(_ target: T, _ codable: Engine.Type) -> SignalProducer<Engine, GINetError> {
        return self.launch(target, codable).attemptMap({ (result) -> Result<Engine, GINetError> in
            guard let result = result.result else { return Result(error: .ParseWrong) }
            return Result(value: result)
        })
    }
    
    open func launch(_ target: T) -> SignalProducer<GIResult<DontCare>, GINetError> {
        return self.launch(target, DontCare.self)
    }
    
    public func go(_ target: T) -> SignalProducer<GIResult<DontCare>, MoyaError> {
        return self.go(target, DontCare.self)
    }

}

extension NetProvider {
    
    public enum Engine<Main: Codable, Second: Codable>: Codable {
        
        case main(Main), second(Second)
        
        public func encode(to encoder: Encoder) throws {
            
        }
        
        
        public init(from decoder: Decoder) throws {
            self = Engine<DontCare, DontCare>.main(DontCare()) as! NetProvider<T>.Engine<Main, Second>
        }
    }

    open func launch<Engine: Codable, Second: Codable>(_ target: Target, main engine: Engine.Type, second: Second.Type) -> SignalProducer<NetProvider.Engine<Engine, Second>, GINetError> {
        let a: [Codable.Type] = [engine, second]
        
        return super.reactive.request(target)
            .parachute().attemptMap { (response) -> Result<NetProvider.Engine<Engine, Second>, GINetError> in
                
                let mainEngine = try? JSONDecoder().decode(GIResult<Engine>.self, from: response.data)
                if let a = mainEngine, let res = a.result {
                    return Result(value: .main(res))
                }
                
                do {
                    let secondEngine = try JSONDecoder().decode(GIResult<Second>.self, from: response.data)
                    guard let res = secondEngine.result else { throw GINetError.ParseWrong }
                    return Result(value: .second(res))
                } catch {
                    return Result(error: GINetError.ParseWrong)
                }
                
        }
//            .attempt({ (result) -> Result<(), GINetError> in
//                switch result {
//                case .success: return Result(())
//                case .failure(let e): return Result(error: e)
//                }
//            })
    }
    
}


//MARK: -

fileprivate protocol TargetSet {
    var pass: Bool { get }
    var fianl: Codable? { get }
//    var code: String? { get }
//    var message: String? { get }
    var info: GINetError.Info { get }
}

extension GIResult: TargetSet {
    var pass: Bool {
        return self.good
    }
    
    var fianl: Codable? {
        return self.result
    }
    
    var info: GINetError.Info {
        return GINetError.Info(code: self.code, message: self.message)
    }

}


extension SignalProducer where Error == MoyaError {
    
    
    /// 将 `MoyaError` 转换为 `GINetError`
    ///
    /// - Returns: SignalProducer<Value, GINetError>
    func parachute() -> SignalProducer<Value, GINetError> {
        return mapError { GINetError.network($0.localizedDescription, $0.response) }
    }
    
}

extension SignalProducer where Value: TargetSet, Error == GINetError {
    
    
    /// 将 业务错误 转化为 `GINetError`
    /// - Discussion: GIResult.good 为 `true` 时，视为成功
    /// - Returns: SignalProducer<Value, GINetError>
    func land() -> SignalProducer<Value, GINetError> {
        return attempt { (result) -> Result<(), GINetError> in
                if result.pass { return Result(()) }
                return Result(error: GINetError.business(result.info))
        }
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
