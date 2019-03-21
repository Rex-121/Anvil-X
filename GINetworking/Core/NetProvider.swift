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
    
    public func go(_ target: T) -> SignalProducer<GIResult<DontCare>, MoyaError> {
        return self.go(target, DontCare.self)
    }

}

// MARK: - Launch - 返回方式为 `<GIResult<解析>, GINetError>`
extension NetProvider {
    
    /// 网络请求 <GIResult<解析>, GINetError>
    ///
    /// - Parameters:
    ///   - target: 网络目标
    ///   - codable: 解析方式
    /// - Returns: GIResult<解析>, GINetError
    open func launch<Engine: Codable>(_ target: T, _ codable: Engine.Type) -> SignalProducer<GIResult<Engine>, GINetError> {
        return super.reactive.request(target)
            .map({ (response) -> GIResult<Engine> in
                do {
                    return try JSONDecoder().decode(GIResult<Engine>.self, from: response.data)
                } catch {
                    return GIResult.ParseWrong
                }
            }).parachute().land()
    }
    
    /// 网络请求 <GIResult<DontCare>, GINetError>
    ///
    /// - Parameters:
    ///   - target: 网络目标
    /// - Returns: GIResult<DontCare>, GINetError
    open func launch(_ target: T) -> SignalProducer<GIResult<DontCare>, GINetError> {
        return self.launch(target, DontCare.self)
    }
    
}

// MARK: - Detach - 返回方式为 `<解析, GINetError>`
extension NetProvider {
    /// 网络请求 <解析, GINetError>
    ///
    /// - Parameters:
    ///   - target: 网络目标
    ///   - codable: 解析方式
    /// - Returns: 解析, GINetError
    open func detach<Engine: Codable>(_ target: T, _ codable: Engine.Type) -> SignalProducer<Engine, GINetError> {
        return self.launch(target, codable).attemptMap({ (result) -> Result<Engine, GINetError> in
            print(result)
            if result.good == false { return Result(error: result.errorInfo) }
            if codable == DontCare.self { return Result(value: DontCare() as! Engine) }
            guard let result = result.result else { return Result(error: .ParseWrong) }
            return Result(value: result)
        })
    }
    
    /// 网络请求 <(), GINetError>
    ///
    /// - Parameters:
    ///   - target: 网络目标
    /// - Returns: (), GINetError
    open func detach(_ target: T) -> SignalProducer<(), GINetError> {
        return self.detach(target, DontCare.self).map { _ in () }
    }
    
}

// MARK: - Docking - 返回方式为 `<(解析, BasicInfo), GINetError>`  or  `<BasicInfo, GINetError>`
extension NetProvider {
    
    /// 网络请求 <(解析, BasicInfo), GINetError>
    ///
    /// - Parameters:
    ///   - target: 网络目标
    ///   - codable: 解析方式
    /// - Returns: <(解析, BasicInfo), GINetError>
    open func docking<Engine: Codable>(_ target: T, _ codable: Engine.Type) -> SignalProducer<(Engine, BasicInfo), GINetError> {
        return self.launch(target, codable).attemptMap({ (result) -> Result<(Engine, BasicInfo), GINetError> in
            if result.good == false { return Result(error: result.errorInfo) }
            if codable == DontCare.self { return Result(value: (DontCare() as! Engine, result.info)) }
            guard let value = result.result else { return Result(error: .ParseWrong) }
            return Result(value: (value, result.info))
        })
    }
    
    /// 网络请求 <BasicInfo, GINetError>
    ///
    /// - Parameters:
    ///   - target: 网络目标
    ///   - codable: 解析方式
    /// - Returns: <BasicInfo, GINetError>
    open func docked<Engine: Codable>(_ target: T, _ codable: Engine.Type) -> SignalProducer<BasicInfo, GINetError> {
        return self.docking(target, codable).map { $1 }
    }

    /// 网络请求 <BasicInfo, GINetError>
    ///
    /// - Parameters:
    ///   - target: 网络目标
    /// - Returns: <BasicInfo, GINetError>
    open func docked(_ target: T) -> SignalProducer<BasicInfo, GINetError> {
        return self.docking(target, DontCare.self).map { $1 }
    }
    
}



// MARK: - 主/次解析方式
extension NetProvider {
    
    /// 用于解析的结果
    ///
    /// - main: 首要解析方式
    /// - second: 次要解析方式
    public enum Engine<Main: Codable, Second: Codable>: Codable {
        case main(Main), second(Second)
        
        public func encode(to encoder: Encoder) throws {
            switch self {
            case let .main(main): try main.encode(to: encoder)
            case let .second(second): try second.encode(to: encoder)
            }
        }

        public init(from decoder: Decoder) throws {
            self = Engine<DontCare, DontCare>.main(DontCare()) as! NetProvider<T>.Engine<Main, Second>
        }
    }

    
    
    
    /// 尝试解码2次 <NetProvider.Engine<Engine, Second>, GINetError>
    ///
    /// - Parameters:
    ///   - target: 网络目标
    ///   - engine: 主解析，失败后采用副解析
    ///   - second: 副解析
    /// - Returns: <NetProvider.Engine<Engine, Second>, GINetError>
    open func launch<Engine: Codable, Second: Codable>(_ target: Target, main engine: Engine.Type, second: Second.Type) -> SignalProducer<NetProvider.Engine<Engine, Second>, GINetError> {
        
        return super.reactive.request(target)
            .parachute()
            .attemptMap { (response) -> Result<NetProvider.Engine<Engine, Second>, GINetError> in
                
                do {
                    let mainEngine = try JSONDecoder().decode(GIResult<Engine>.self, from: response.data)
                    if mainEngine.good == false { return Result(error: mainEngine.errorInfo) }
                    if let res = mainEngine.result { return Result(value: .main(res)) }
                    throw GINetError.ParseWrong
                }
                catch {
                    do {
                        let secondEngine = try JSONDecoder().decode(GIResult<Second>.self, from: response.data)
                        guard let res = secondEngine.result else { throw GINetError.ParseWrong }
                        return Result(value: .second(res))
                    } catch {
                        return Result(error: GINetError.ParseWrong)
                    }
                }
                
        }
    }
    
    private func coding(_ engine: Decodable.Type, with data: Data) throws {
    
//        let mainEngine = try JSONDecoder().decode(engine.self, from: data)
        
    }
    
}


//MARK: - TargetSet

fileprivate protocol TargetSet {
    var pass: Bool { get }
    var fianl: Codable? { get }
    var info: BasicInfo { get }
}

extension GIResult: TargetSet {
    var pass: Bool {
        return self.good
    }
    
    var fianl: Codable? {
        return self.result
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
