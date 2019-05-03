//
//  Galleries.swift
//  GetGalleryImages
//
//  Created by Mohamed Mohsen on 5/1/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import Foundation

class FlickrGalleries{
    
    static func getGalleryPhotosURLUsingFlickrAPI() -> [Photo]{
        var galleryPhotos = [Photo]()
        let flickrParameters =
            [
                FlickrConstants.FlickrParameterKeys.Method : FlickrConstants.Galleries.Methods.flickr_galleries_getPhotos.rawValue,
                FlickrConstants.FlickrParameterKeys.APIKey : FlickrConstants.APIKeys.sleepingInTheLibraryAPIKey.rawValue,
                FlickrConstants.FlickrParameterKeys.GalleryID : FlickrConstants.Galleries.ID.sleepingInTheLibraryID.rawValue,
                FlickrConstants.FlickrParameterKeys.Extras : FlickrConstants.Extras.url_m.rawValue,
                FlickrConstants.FlickrParameterKeys.Format : FlickrConstants.OutputResponseFormat.Format.JSON.rawValue,
                FlickrConstants.FlickrParameterKeys.NoJSONCallback : FlickrConstants.OutputResponseFormat.JSONCallback.DisableJSONCallback.rawValue
                ] as [String: AnyObject]
        
        let galleryURLString = FlickrConstants.Flickr.APIBaseURL + escapedParameters(parameters: flickrParameters)
        //print(galleryURLString)
        if let galleryURL = URL(string: galleryURLString){
            let httpRequest = URLRequest(url: galleryURL)
            //httpRequest.httpMethod = HttpConstants.HttpMethod.GET
            let group = DispatchGroup()
            group.enter()
            let task = URLSession.shared.dataTask(with: httpRequest) { (data, urlResponse, error) in
                // if an error occurs, print it and re-enable the UI
                func displayError(_ error: String) {
                    print(error)
                    print("URL at time of error: \(galleryURL)")
                }

                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    displayError("There was an error with your request: \(error)")
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    displayError("Your request returned a status code other than 2xx!")
                    return
                }

                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    displayError("No data was returned by the request!")
                    return
                }
                
                // parse the data
                let dataAsJSON: AnyObject!
                do{
                    dataAsJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                }catch{
                    print("Error! Could not parse the data to JSON.")
                    return
                }
                
                /* GUARD: Did Flickr return an error (stat != ok)? */
                guard let stat = dataAsJSON[FlickrConstants.FlickrResponseKeys.Status] as? String, stat == FlickrConstants.FlickrResponseValues.OKStatus else {
                    displayError("Flickr API returned an error. See error code and message in \(dataAsJSON!)")
                    return
                }
                
                /* GUARD: Are the "photos" and "photo" keys in our result? */
                guard let photosDictionary = dataAsJSON[FlickrConstants.FlickrResponseKeys.Photos] as? [String: AnyObject], let photoArray = photosDictionary[FlickrConstants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                    displayError("Cannot find keys '\(FlickrConstants.FlickrResponseKeys.Photos)' and '\(FlickrConstants.FlickrResponseKeys.Photo)' in \(dataAsJSON!)")
                    return
                }
                
                for photoJSON in photoArray{
                    guard let urlString = photoJSON[FlickrConstants.Extras.url_m.rawValue] as? String else {
                        displayError("Invalid URL for the photo: \(photoJSON)")
                        return
                    }
                    
                    guard let title = photoJSON[FlickrConstants.CommonAttributes.title.rawValue] as? String else {
                        displayError("Invalid title for the photo: \(photoJSON)")
                        return
                    }
                    
                    guard let url = URL(string: urlString) else{
                        displayError("Invalid URL format, URL: \(urlString)")
                        return
                    }
                    
                    galleryPhotos.append(Photo(title: title, url: url))
                }
                group.leave()
            }
            task.resume()
            group.wait()
        }
        return galleryPhotos
    }
    
    private static func escapedParameters(parameters: [String:AnyObject]) -> String {
        if parameters.isEmpty {
            return String() //return empty string
        }
        
        var keyValuePairs = [String]()
        
        for (key, value) in parameters{
            
            //convert value to be in string format
            let valueAsString = "\(value)"
            
            //Returns a new string created by replacing all characters in the string not in the specified set with percent encoded characters.
            let valueWithReplacingEscappedParameters = valueAsString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            //append the new value in the KeyValuePairs
            keyValuePairs.append(key + "=\(valueWithReplacingEscappedParameters!)")
        }
        //join an ampersand "&" between every parameter in the parameters
        //add a question mark "?" at the beginning of the method parameter
        return "?\(keyValuePairs.joined(separator: "&"))"
    }
    
}
