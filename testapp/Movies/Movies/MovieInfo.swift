//
//  MovieInfo.swift
//  Movies
//
//  Created by iosdeveloper on 12/17/18.
//  Copyright © 2018 MobileDevTest. All rights reserved.
//

import UIKit


class MovieInfo: NSObject {
    let id:String!
    let adult:Bool!
    let backdropPath:String!
    let posterImagePath:String!

    let title:String!
    let originalTitle:String!
    let releaseDate:String!
    let video:Bool!
    let votePercentage: Float!
    let voteCount: Int!
    let overview:String!
    var posterImage: UIImage? = nil
    init(_ info : [String : Any]) {
        id = Utility.getString(info: info, key: "id")
        adult = Utility.getBool(info: info, key: "adult")
        backdropPath = Utility.getString(info: info, key: "backdrop_path")
        posterImagePath = Utility.getString(info: info, key: "poster_path")

        title = Utility.getString(info: info, key: "title")
        originalTitle = Utility.getString(info: info, key: "original_title")
        releaseDate = Utility.getString(info: info, key: "release_date")
        video = Utility.getBool(info: info, key: "video")
        votePercentage = Utility.getNumber(info: info, key: "vote_average").floatValue
        voteCount = Utility.getNumber(info: info, key: "vote_count").intValue
        overview = Utility.getString(info: info, key: "overview")
    }
    
    
}
class Utility{
    static func getString(info:[String : Any],key: String) -> String {
        if let str = info[key] as? String {
            return str
        }else if let number = info[key] as? NSNumber {
            return "\(number)"
        }else if let info = info[key]{
            return "\(info)"
        }
        return ""
    }
    static func getBool(info:[String : Any],key: String) -> Bool {
        if let bool = info[key] as? Bool {
            return bool
        }
        return false
    }
    static func getNumber(info:[String : Any],key: String) -> NSNumber {
        if let number = info[key] as? NSNumber {
            return number
        }
        return false
    }
}
