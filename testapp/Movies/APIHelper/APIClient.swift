//
//  APIClient.swift
//  Movies
//
//  Created by iosdeveloper on 12/17/18.
//  Copyright © 2018 MobileDevTest. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}

public class APIClient {
    
    var session: URLSession
    
    public init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Accept" : accept_type,
        ]
        
        self.session = URLSession(configuration: configuration,
                                  delegate: nil,
                                  delegateQueue: OperationQueue.main)
    }
    
    public func request(path: String,
                        baseURL: String = "",
                        method: HTTPMethod = .POST,
                        body: String?,
                        completion: ((Data?,  NSError?,_ response:HTTPURLResponse) -> ())?) -> URLSessionDataTask {
        let request: NSMutableURLRequest
        let urlString = baseURL + path
        request = NSMutableURLRequest(url: NSURL(string: urlString as String)! as URL)
        if let jsonData = body {
            request.httpBody = jsonData.data(using: .utf8)
        }
        request.httpMethod = method.rawValue
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if (data == nil || error != nil) {
                    if response == nil {
                        completion?(nil, error as NSError?,HTTPURLResponse.init())
                    }else{
                        completion?(nil, error as NSError?,response as! HTTPURLResponse)
                    }
                } else {
                    print(String.init(data: data!, encoding: String.Encoding.ascii) ?? "")
                    completion?(data, error as NSError?,response as! HTTPURLResponse)
                }
            }
        }
        task.resume()
        return task
    }
    
    
    public func request(path: String,
                        baseURL: String = "",
                        method: HTTPMethod = .GET,
                        parameters: [String : String]?,
                        completion: ((Data?,  NSError?,_ response:HTTPURLResponse) -> ())?) -> URLSessionDataTask {
        let request: NSMutableURLRequest
        
        if method == .POST {
            let urlString = baseURL + path
            request = NSMutableURLRequest(url: NSURL(string: urlString as String)! as URL)
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters as Any, options: .prettyPrinted) {
                request.httpBody = jsonData
            }
        }
        else {
            let urlString:String?
            if parameters != nil {
                urlString  = baseURL + path + "?" + buildQueryString(fromDictionary: parameters! )
            }else{
                urlString = kAPIBaseURL + path as String
            }
            request = NSMutableURLRequest(url: NSURL(string: urlString! )! as URL)
        }
        request.httpMethod = method.rawValue
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if (data == nil || error != nil) {
                    if response == nil {
                        completion?(nil, error as NSError?,HTTPURLResponse.init())
                    }else{
                        completion?(nil, error as NSError?,response as! HTTPURLResponse)
                    }
                } else {
                    completion?(data, error as NSError?,response as! HTTPURLResponse)
                }
            }
        }
        
        task.resume()
        
        return task
    }
    
    private func buildQueryString(fromDictionary parameters: [String: String]) -> String {
        var urlVars = [String]()
        for (key, var val) in parameters {
            val = val.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            urlVars += [key + "=" + "\(val)"]
        }
        return urlVars.joined(separator: "&")
    }
}

