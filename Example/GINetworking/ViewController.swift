//
//  ViewController.swift
//  GINetworking
//
//  Created by Rex on 12/06/2018.
//  Copyright (c) 2018 Rex. All rights reserved.
//

import UIKit

import GINetworking

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NetProvider<NetBusiness, GIVersion>().go(.appVersion) { (r) in
            switch r {
            case .success(let result):
                print(result.result ?? "")
                print("gasdf" + result.message!)
            case .failure(_): break
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

