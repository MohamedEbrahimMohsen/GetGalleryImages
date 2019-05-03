//
//  ViewController.swift
//  GetGalleryImages
//
//  Created by Mohamed Mohsen on 4/30/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var grabNewImageButn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableUI(isEnabled: true)
    }

    @IBAction func grabNewImageFromGallery(_ sender: Any) {
        enableUI(isEnabled: false)
        let galleryPhotos = FlickrGalleries.getGalleryPhotosURLUsingFlickrAPI()
        
        guard galleryPhotos.count > 0 else {
            DispatchQueue.main.async {
                self.imageTitle.text = "Sorry, this gallery has no images."
                self.enableUI(isEnabled: true)
            }
            return
        }
        
        let randIndex = Int(arc4random()) % galleryPhotos.count
        let photo = galleryPhotos[randIndex]
        let task = URLSession.shared.dataTask(with: photo.url, completionHandler: {
            (data, urlResponse, error) in
            
            /* GUARD: Was there an error? */
            guard error == nil else{
                print("An error happened during fetching the URL: \(photo.url!), with error message: \(error!)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by loading the URL: \(photo.url!)")
                return
            }

            /* GUARD: Could be binded as an image */
            guard let image = UIImage(data: data) else {
                print("Returned data couldn't be binded as an image, data: \(data)")
                return
            }

            DispatchQueue.main.async {
                self.imageView.image = image
                self.imageTitle.text = photo.title
            }
        })
        task.resume()

        enableUI(isEnabled: true)
    }
    
    //All we need to deactivate the "Grab New Photo From Gallery" button
    //So, user can't press it while we are still fetching & loading the image
    func enableUI(isEnabled: Bool){
        self.grabNewImageButn.isEnabled = isEnabled
    }
}

