//
//  Movie.swift
//  AssignmentWeek1
//
//  Created by Ngoc Do on 3/16/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import Foundation

class Movie{
    var title:String?
    var overview:String?
    var urlImage:String?
    var releaseDate:String?
    var voteCout:Int?
    
    //init
    init(dictionary: NSDictionary) {
        title = dictionary["original_title"] as? String
        overview =  dictionary["overview"] as?String
        releaseDate = dictionary["release_date"] as? String
        voteCout = dictionary["vote_count"] as? Int
        urlImage = dictionary["poster_path"] as? String
        
    }
    class func cashDictionaryToObject(array array: [NSDictionary]) -> [Movie] {
        var movieList = [Movie]()
        for dictionary in array {
            let business = Movie(dictionary: dictionary)
            movieList.append(business)
        }
        return movieList
    }
    class func loadData(url:NSURL, completion:(movies:[Movie])->Void){
        var moviesList:[Movie] = []
        
        let request = NSURLRequest(URL: url)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            moviesList = cashDictionaryToObject(array:(responseDictionary["results"] as? [NSDictionary])!)
                            completion(movies: moviesList)
                    }
                }
        });
        task.resume()
        
        
    }


}