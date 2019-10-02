//
//  APIManager.swift
//  UberTask
//
//  Created by Epos Admin on 01/10/19.
//  Copyright © 2019 Epos Admin. All rights reserved.
//

import Foundation
import SystemConfiguration
class APIManager {
        func getFlickrPhotos(urlStr: String,completion: @escaping (_ flickrPhotos: Flickr_Base?, _ error: Error?) -> Void) {
            if (isInternetAvailable()) {
                getJSONFromURL(urlString: urlStr) { (data, error) in
                    guard let data = data, error == nil else {
                        print("Failed to get data")
                        return completion(nil, error)
                    }
                    self.createFlickrObjectWith(json: data, completion: { (flickrPhotos, error) in
                        if let error = error {
                            print("Failed to convert data")
                            return completion(nil, error)
                        }
                        return completion(flickrPhotos, nil)
                    })
                }
            }else {
                AlertView.showAlert(message: "Please check your network and try again")
            }
    }
    //MARK: Check internet connection
    func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}
extension APIManager {
    private func getJSONFromURL(urlString: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        let urlStr = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
       
        guard let url:URL = URL(string: urlStr ?? "" ) else {
            print("Error: Cannot create URL from string")
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else {
                print("Error calling api")
                return completion(nil, error)
            }
            guard let responseData = data else {
                print("Data is nil")
                return completion(nil, error)
            }
            completion(responseData, nil)
        }
        task.resume()
    }
    private func createFlickrObjectWith(json: Data, completion: @escaping (_ data: Flickr_Base?, _ error: Error?) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let flickrPhotos = try decoder.decode(Flickr_Base.self, from: json)
            return completion(flickrPhotos, nil)
        } catch let error {
            print("Error creating current flickr photos from JSON because: \(error.localizedDescription)")
            return completion(nil, error)
        }
    }
}
