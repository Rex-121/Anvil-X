import XCTest

@testable import Anvil

import ReactiveSwift

class Tests: XCTestCase {
    
    
    var net: NetProvider<NetBusiness>!
    
    override func setUp() {
        super.setUp()
        
        net = NetProvider()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        net = nil
        
    }
    
    
    
    /**
     测试成功获取值，不应出现网络错误
     */
    func testSupposeSuccess() {
        
        print("测试成功获取值，不应出现网络错误")
        
        let success = XCTestExpectation(description: "success")
        
        let action = Action { self.net.detach(.version) }
        
        action.values.observeValues { (version) in
            print("测试结果---", version)
            XCTAssert(true)
            success.fulfill()
        }
        
        action.errors.observeValues { e in
            print(e)
            XCTAssert(false)
            success.fulfill()
        }
        
        action.apply().start()
        
        wait(for: [success], timeout: 60)
        
    }

    
    /**
     测试解析错误，不应出现网络错误
     */
//    func testWrongPaser() {
//
//        print("测试解析错误，不应出现网络错误")
//
//        let wrongPaser = XCTestExpectation(description: "wrongPaser")
//
//        let action = Action { self.net.detach(.version, Int.self) }
//
//        action.values.observeValues { (version) in
//            print(version)
//            XCTAssert(false)
//            wrongPaser.fulfill()
//        }
//
//        action.errors.observeValues { (error) in
//            switch error {
//            case .business(let info):
//                print("测试结果---", info)
//                XCTAssert(true, error.description)
//            case let .network(msg, res):
//                XCTAssert(false, msg)
//                print(msg, res ?? "")
//            }
//            wrongPaser.fulfill()
//        }
//
//        action.apply().start()
//
//        wait(for: [wrongPaser], timeout: 60)
//
//    }
    
    
    /**
     测试网络错误404，一定出现网络错误
     */
//    func testWrong404() {
//
//        print("测试网络错误404，一定出现网络错误")
//
//        let wrong404 = XCTestExpectation(description: "wrong404")
//
//        let action = Action { self.net.detach(.net404) }
//
//        action.values.observeValues { (_) in
//            XCTAssert(false)
//            wrong404.fulfill()
//        }
//
//        action.errors.observeValues { (error) in
//            switch error {
//            case .business(let info):
//                print(info)
//                XCTAssert(false)
//            case let .network(msg, _):
//                print("测试结果---", msg)
//                XCTAssert(true, msg)
//            }
//            wrong404.fulfill()
//        }
//
//        action.apply().start()
//
//        wait(for: [wrong404], timeout: 60)
//
//    }
//
//
//    /**
//     测试业务错误，不应出现网络错误
//     */
//    func testWrongAtBusiness() {
//
//        print("测试业务错误，不应出现网络错误")
//
//        let wrongAtBus = XCTestExpectation(description: "wrongAtBus")
//
//        let action = Action { self.net.detach(.wrongAtBusiness) }
//
//        action.values.observeValues { (_) in
//            XCTAssert(false)
//            wrongAtBus.fulfill()
//        }
//
//        action.errors.observeValues { (error) in
//            switch error {
//            case .business(let info):
//                print("测试结果---", info)
//                XCTAssert(true)
//            case let .network(msg, _):
//                print(msg)
//                XCTAssert(false, msg)
//            }
//            wrongAtBus.fulfill()
//        }
//
//        action.apply().start()
//
//        wait(for: [wrongAtBus], timeout: 60)
//
//    }
    
}
