//
//  ViewController.swift
//  GINetworking
//
//  Created by Rex on 12/06/2018.
//  Copyright (c) 2018 Rex. All rights reserved.
//

import UIKit

import GINetworking

import Moya

class ViewController: UIViewController {
    
    struct GIVersion: Codable {
        let id: Int?
        let versionCode: String?
        let leastVersion: String?
        let versionName: String
        let updateInformation: String?
        let phoneType: Int?
        let downloadAddress: URL
        let isUpdate: Int
    }

    let n = NetProvider<NetBusiness>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        n.go(.appVersion, GIVersion.self).startWithResult { (result) in
            print(result)
        }
        
        n.go(.appVersion).startWithResult { (result) in
            print(result)
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

enum NetBusiness {
    case validate(String, String), issueCoin, login(String, String), appVersion
}



extension TargetType {
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
