//
//  ViewController.swift
//  UberTask
//
//  Created by Epos Admin on 01/10/19.
//  Copyright © 2019 Epos Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    private let apiManager = APIManager()
    private(set) var photosViewModel: PhotosViewModel?
    
    var searchResult: Flickr_Base? {
        didSet {
            guard let searchResult = searchResult else { return }
            photosViewModel = PhotosViewModel.init(currentPhotos: searchResult)
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        goButton.isEnabled = false
    }
    private func getPhotos() {
        apiManager.getFlickrPhotos(urlStr: Config.flickrUrl+searchTextField.text!) { (photos, error) in
            if let error = error {
                print("Get photos error: \(error.localizedDescription)")
                return
            }
            guard let photos = photos  else { return }
            self.searchResult = photos
            print(photos)
        }
    }
    func reloadData() {
        self.photosCollectionView.dataSource=self
        self.photosCollectionView.delegate=self
        self.photosCollectionView.reloadData()
    }
    //MARK: - Search Photos
    @IBAction func kepadGoAction(_ sender: Any) {
        getPhotosFromUrl()
    }
    @IBAction func searchPhotos(_ sender: Any) {
        getPhotosFromUrl()
    }
    
    private func getPhotosFromUrl() {
        globalInstance.shared.cache.removeAllObjects()
        globalInstance.shared.mainPhotoArr.removeAll()
        searchTextField.resignFirstResponder()
        getPhotos()
    }
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if range.location > 0 {
                goButton.isEnabled = true
            }else {
                goButton.isEnabled = false
            }
            return true
    }
}

//MARK: - UICollectionView DataSource & Delegate Methods
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return globalInstance.shared.mainPhotoArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath as IndexPath) as! PhotosCollectionViewCell
        photosViewModel?.cellForItem(indexPath: indexPath, completion: { (image,err) -> Void in
            cell.photoImageView.image = image
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == globalInstance.shared.mainPhotoArr.count - 1{
            print("success")
            getPhotos()
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (photosViewModel?.collectionViewLayout(layout: collectionViewLayout, collectionView: collectionView))!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return (photosViewModel?.sizeForItemAtIndexPath(collectionView: collectionView))!
    }
}

