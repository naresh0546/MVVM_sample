//
//  UberTaskTests.swift
//  UberTaskTests
//
//  Created by Epos Admin on 01/10/19.
//  Copyright © 2019 Epos Admin. All rights reserved.
//

import XCTest
@testable import UberTask

class UberTaskTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Unit testing for flickr live APi
    func testFlickrLiveDataWithCodable() {
        
        guard let gitUrl = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736& format=json&nojsoncallback=1&safe_search=1&text=") else { return }
        let promise = expectation(description: "Codable Request")
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(Flickr_Base.self, from: data)
                XCTAssertTrue(gitData.photos?.photo?[0].id == "48835659482")
                XCTAssertTrue(gitData.photos?.photo?[0].secret == "1234")
                XCTAssertTrue(gitData.photos?.photo?[0].farm == 5455)
                XCTAssertTrue(gitData.photos?.photo?[0].server == "12345")
                
                promise.fulfill()
            } catch let err {
                print("Err", err)
            }
            }.resume()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // Unit testing for flickr dummy APi
    func testFlickrDummyJsonData() {
        
        let promise = expectation(description: "Dummy json data")
        if let url = Bundle.main.url(forResource: "Feed", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(Flickr_Base.self, from: data)
                XCTAssertTrue(gitData.photos?.photo?[0].id == "48835659482")
                XCTAssertTrue(gitData.photos?.photo?[0].secret == "3a3301a41e")
                XCTAssertTrue(gitData.photos?.photo?[0].farm == 66)
                XCTAssertTrue(gitData.photos?.photo?[0].server == "65535")
                promise.fulfill()
            } catch {
                print("error:\(error)")
            }
            waitForExpectations(timeout: 10, handler: nil)
        }
    }
}
