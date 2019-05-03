//
//  FlickrConstants.swift
//  GetGalleryImages
//
//  Created by Mohamed Mohsen on 4/30/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//


struct FlickrConstants {
    
    // MARK: Flickr
    struct Flickr {
        static let APIBaseURL = "https://api.flickr.com/services/rest/"
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
    }
    
    // MARK: Flickr Output Response Format
    struct OutputResponseFormat{
        enum Format: String {
            case JSON = "json"
            case XML = "XML"
        }
        
        enum JSONCallback: String{
            case DisableJSONCallback = "1" /* 1 means "yes" */
            case EnableJSONCallback  = "0"
        }
    }
    
    // MARK: Flickr Galleries
    struct Galleries{
        enum Methods: String{
            case flickr_galleries_getPhotos = "flickr.galleries.getPhotos"
        }
        
        enum ID: String{
            case sleepingInTheLibraryID = "169786254-72157708327683714" /* Sleeping In The Library Gallery API ID */
        }
    }
    
    // MARK: Flickr Extras
    enum Extras: String{
        case url_m = "url_m"
    }
    
    enum CommonAttributes: String{
        case title = "title"
    }
    
    // MARK: Flickr API Keys for the Applications
    enum APIKeys: String{
        case sleepingInTheLibraryAPIKey = "9bd28741be28392a227491f44bb604ea" /* Sleeping In The Library API Key */
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
}

// MARK: HTTP Constants
struct HttpConstants{
    struct HttpMethod{
        static let GET = "GET"
        static let POST = "POST"
    }
}
