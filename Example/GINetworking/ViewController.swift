//
//  ViewController.swift
//  GINetworking
//
//  Created by Rex on 12/06/2018.
//  Copyright (c) 2018 Rex. All rights reserved.
//

import UIKit

import Anvil

import Moya

import Alamofire


struct K: AnvilSessionProvider {
    
}

class ViewController: UIViewController {
    
    

    let n = NetProvider<NetBusiness>()
    let nz = NetProvider<NetBusiness>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(K.defaultHTTPHeader)
        
//        n.detach(.version, SampleVersionWrong.self).startWithResult({ (result) in
//            print(result)
//        })
//        
//        n.detach(.wrongAtBusiness, SampleVersionWrong.self).startWithResult({ (result) in
//            print(result)
//        })
        
//        k.brief(.login, String.self).startWithResult { print($0) }
        
        nz.baseRequest(.version, SampleVersion.self).startWithResult { (result) in
            print(result)
        }
        
    }
    
//    let k = NetProvider<XNet>()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
 

enum xxxnet {
    case login
    
    
}


extension xxxnet: AnvilTargetType {    
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        return URL(string: "http://192.168.1.215:38090/gichain-exchange-app")!
    }
    
    var path: String {
        switch self {
        case .login: return "/api/user/validLogin"
        }
    }
    
    var method: Moya.Method { return .post }
    
    var sampleData: Data { return Data() }
    
    var task: Task { return .uploadMultipart(["account":"a", "password":"p.gi.md5"].multipartData()) }
}

