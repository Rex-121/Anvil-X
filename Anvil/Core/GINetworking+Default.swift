//
//  GINetworking+Default.swift
//  Alamofire
//
//  Created by Ray on 2018/11/16.
//

import Alamofire

public protocol GI_NetworkingSession {
    ///默认session
    static func defaultSession() -> SessionManager
    ///默认请求头
    static var defaultHTTPHeader: HTTPHeaders { get }
    ///默认安全策略
    static func defaultPolicy() -> ServerTrustPolicyManager?
    
}

public extension GI_NetworkingSession {
    
    
    static func defaultSession() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 30
        configuration.httpAdditionalHeaders = Self.defaultHTTPHeader
        return SessionManager(configuration: configuration, delegate: SessionDelegate(), serverTrustPolicyManager: Self.defaultPolicy())
    }
    
    
    static var defaultHTTPHeader: HTTPHeaders {
        
        // Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"

        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
        }.joined(separator: ", ")

        // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
        // Example: `iOS Example/1.0 (org.alamofire.iOS-Example; build:1; iOS 10.0.0) Alamofire/4.0.0`
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

                    let osName: String = {
                        #if os(iOS)
                            return "iOS"
                        #elseif os(watchOS)
                            return "watchOS"
                        #elseif os(tvOS)
                            return "tvOS"
                        #elseif os(macOS)
                            return "OS X"
                        #elseif os(Linux)
                            return "Linux"
                        #else
                            return "Unknown"
                        #endif
                    }()

                    return "\(osName) \(versionString)"
                }()

                return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion))"
            }

            return "Anvil"
        }()

        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        // Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
//        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
//
//        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
//        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
//            let quality = 1.0 - (Double(index) * 0.1)
//            return "\(languageCode);q=\(quality)"
//            }.joined(separator: ", ")
//
//        // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
//        // Example: `iOS Example/1.0 (build:1; iOS 10.0.0)`
//        let userAgent: String = {
//            if let info = Bundle.main.infoDictionary {
//                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
//                let appVersion = Bundle.main.x.appVersion.versionString
//                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
//
//                let osNameVersion: String = {
//                    let version = ProcessInfo.processInfo.operatingSystemVersion
//                    let versionString = version.versionString
//
//                    let osName: String = XKit.osName()
//
//                    return "\(osName) \(versionString)"
//                }()
//                return "\(executable)/\(appVersion) (build:\(appBuild); \(osNameVersion))"
//            }
//
//            return "Alamofire"
//        }()
//
//        return [
//            "Accept-Encoding": acceptEncoding,
//            "Accept-Language": acceptLanguage,
//            "User-Agent": userAgent
//        ]
    }
    
    
    static func defaultPolicy() -> ServerTrustPolicyManager? { return ServerTrustPolicyManager(policies: [String : ServerTrustPolicy]()) }
    
    
    
}

