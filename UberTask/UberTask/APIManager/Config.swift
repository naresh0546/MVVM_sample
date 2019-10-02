//
//  Config.swift
//  UberTask
//
//  Created by Epos Admin on 01/10/19.
//  Copyright © 2019 Epos Admin. All rights reserved.
//

import Foundation

struct Config {
    static let flickrUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736& format=json&nojsoncallback=1&safe_search=1&text="
}

struct globalInstance {
    static var shared = globalInstance()
    var mainPhotoArr = [String]()
    var cache:NSCache<AnyObject, AnyObject>! = NSCache()
}
