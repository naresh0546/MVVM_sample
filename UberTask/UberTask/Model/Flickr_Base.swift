//
//  Flickr_Base.swift
//  UberTask
//
//  Created by Epos Admin on 01/10/19.
//  Copyright © 2019 Epos Admin. All rights reserved.
//

import Foundation
struct Flickr_Base : Codable {
    let photos : Photos?
    let stat : String?
    
    enum CodingKeys: String, CodingKey {
        
        case photos = "photos"
        case stat = "stat"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        photos = try values.decodeIfPresent(Photos.self, forKey: .photos)
        stat = try values.decodeIfPresent(String.self, forKey: .stat)
    }
    
}
