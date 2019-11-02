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


struct K: GI_NetworkingSession {
    
}

class ViewController: UIViewController {
    
    

    let n = NetProvider<NetBusiness>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(K.defaultHTTPHeader)
        
//        n.detach(.version, SampleVersion.self).startWithResult({ (result) in
//            print(result)
//        })
//        
        n.detach(.version, SampleVersionWrong.self).startWithResult({ (result) in
            print(result)
        })
        
        n.detach(.wrongAtBusiness, SampleVersionWrong.self).startWithResult({ (result) in
            print(result)
        })
        
        
//        ServerTrustPolice(evaluators: PinnedCertificates())
//
//        PinnedCertificatesTrustEvaluator(certificates: [SecCertificate], acceptSelfSignedCertificates: <#T##Bool#>, performDefaultValidation: <#T##Bool#>, validateHost: <#T##Bool#>)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

