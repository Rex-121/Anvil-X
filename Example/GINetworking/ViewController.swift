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
        
        n.detach(.version, GIVersion.self).startWithResult({ (result) in
            print(result)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

enum NetBusiness: TargetType {
    
    case version
    
    var baseURL: URL {
        return URL(string: "https://tcapp.dcpay.vip/merchant_app")!
    }
    
    var path: String {
        return "/app/version/list"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        let a = MultipartFormData(provider: MultipartFormData.FormDataProvider.data("4".data(using: .utf8)!), name: "type")
        return .uploadMultipart([a])
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
