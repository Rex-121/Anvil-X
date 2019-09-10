//
//  NetProvider.swift
//  GI_Networking
//
//  Created by Ray on 2018/11/16.
//

import Moya

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
}

