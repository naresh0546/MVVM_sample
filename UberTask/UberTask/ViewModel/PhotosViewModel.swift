//
//  PhotosViewModel.swift
//  UberTask
//
//  Created by Epos Admin on 01/10/19.
//  Copyright © 2019 Epos Admin. All rights reserved.
//

import Foundation
import UIKit
struct PhotosViewModel {
    let currentPhotos: Flickr_Base
    
    init(currentPhotos: Flickr_Base) {
        self.currentPhotos = currentPhotos
        updateProperties()
    }
    private mutating func updateProperties() {
            var subPhotoArr = [String]()
            for photo in currentPhotos.photos?.photo ?? [] {
                let formPhotoURL = "http://farm\(photo.farm ?? 0).static.flickr.com/\(photo.server ?? "")/\(photo.id ?? "")_\(photo.secret ?? "").jpg"
                print(formPhotoURL)
                subPhotoArr.append(formPhotoURL)
            }
         globalInstance.shared.mainPhotoArr.append(contentsOf: subPhotoArr)
        }
    func cellForItem(indexPath:IndexPath, completion: @escaping (_ img: UIImage?, _ error: Error?) -> Void)  {
        var img:UIImage =  UIImage(named: "placeholder")!
        if (globalInstance.shared.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
            print("Cached image used, no need to download it")
            completion(globalInstance.shared.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage,nil)
        }else{
            if (globalInstance.shared.mainPhotoArr.count != 0) {
                let url:URL! = URL(string: globalInstance.shared.mainPhotoArr[indexPath.item])
                let task = URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    guard error == nil else {
                        print("Error calling api")
                        return
                    }
                    guard response != nil else {
                        print("response is nil")
                        return
                    }
                    if let data = try? Data(contentsOf: url){
                        DispatchQueue.main.async(execute: { () -> () in
                            img = UIImage(data: data) ?? UIImage()
                            globalInstance.shared.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                            completion(img,nil)
                        })
                    }
                })
                task.resume()
            }
             completion(img,nil)
        }
    }
    func collectionViewLayout(layout: UICollectionViewLayout, collectionView: UICollectionView) -> CGSize {
        
        let nbCol = 3
        let flowLayout = layout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(nbCol - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(nbCol))
        return CGSize(width: size, height: size)
    }
    func sizeForItemAtIndexPath(collectionView: UICollectionView) ->CGSize {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width/3.0 //Display Three elements in a row.
        collectionViewSize.height = 80
        return collectionViewSize
    }
}
class AlertView: NSObject {
    class func showAlert(message: String) {
        let alert = UIAlertController(title: "Flickr", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}



