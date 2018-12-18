//
//  APIHelper.swift
//  Movies
//
//  Created by iosdeveloper on 12/17/18.
//  Copyright © 2018 MobileDevTest. All rights reserved.
//


import Foundation
import UIKit

typealias APICompletionBlock = (_ result: Any?, _ error: NSError?,_ response:HTTPURLResponse) -> Void

class APIHelper: NSObject {
    class func fetchMoviesList(_ completion: @escaping APICompletionBlock) {
        let _ = APIClient().request(path: kTrendingMovies, baseURL: kAPIBaseURL, method:.GET, parameters:[apiKey : kAPI_Key], completion: { (data, error,response) in
            if let jsondata = data { //Data Received
                do {
                    if let moviesInfo = try JSONSerialization.jsonObject(with: jsondata, options:.allowFragments) as? [String: Any], let resultList = moviesInfo["results"] as? [[String : Any]]{
                        var moviesList = [MovieInfo]()
                        for result in resultList {
                            moviesList.append(MovieInfo(result))
                        }
                        completion(moviesList, error,response)
                        return;
                    }
                    completion(nil, error,response)
                }catch{
                    completion(nil, nil,response)
                }
            } else { //Failed to receive the data
                completion(nil, error,response)
            }
        });
    }
    class func getImageWithPath(_ imagePath: String, completion: @escaping APICompletionBlock) {
        let _ = APIClient().request(path: imagePath, baseURL: kImageBaseURL, method:.GET, parameters:[apiKey : kAPI_Key], completion: { (data, error,response) in
            if let imageData = data { //Data Received
                completion(UIImage.init(data: imageData), error,response)
            }else { //Failed to receive the data
                completion(nil, error,response)
            }
        });
    }
}
