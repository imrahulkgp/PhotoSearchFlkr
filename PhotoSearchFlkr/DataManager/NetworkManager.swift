//
//  NetworkManager.swift
//  PhotoSearchFlkr
//
//  Created by Rahul Gupta on 25/03/20.
//  Copyright © 2020 Dunzo. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}


class NetworkManager {
    private init() {}
    fileprivate var uniqueDataTask: URLSessionDataTask?
    static let sharedManager = NetworkManager()
    lazy var defaultSession:URLSession = {
        var sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60.0
        return URLSession(configuration: sessionConfig)
    }()
    
    private func createUrlWithPath(_ url:String, parameters: [String : Any]? = nil) -> String {
        var urlString: String = url
        
        if let param = parameters {
            let parameterString = param.stringFromHttpParameters()
            urlString += "?\(parameterString)"
        }
        
        return urlString
    }
    
    private func createRequest(_ method: HTTPMethod, URLString: String, parameters: [String : Any]?, headers: [String : String]? = nil) -> URLRequest {
        let getRequestParam = (method == .get) ? parameters : nil
        let otherRequestParam = (method != .get) ? parameters : nil
        let urlString = self.createUrlWithPath(URLString, parameters: getRequestParam)
        var request = URLRequest.init(url: urlString.url!)
        
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let otherRequestParam = otherRequestParam {
            request.httpBody =  try? JSONSerialization.data(withJSONObject: otherRequestParam, options: [])
        }
        
        return request
    }
    
    func sendRequest(_ method:HTTPMethod,
                     url:String,
                     param: [String : Any]?,
                     headers: [String : String]?,
                     withCompletion completionHandler: @escaping (_ data: Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void)  {
        
        let request = self.createRequest(method, URLString: url, parameters: param, headers: headers)
        print("===================================================")
        print("Request URL: \(request.url?.absoluteString ?? "") \nMethod: \(request.httpMethod ?? "None") \nHeaders: \(request.allHTTPHeaderFields?.description ?? "None") \nParams: \(param?.description ?? "None")")
        print("===================================================")
        
        let dataTask: URLSessionDataTask? = defaultSession.dataTask(with: request, completionHandler: {(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void in
            let httpResponse = response as? HTTPURLResponse
            if error != nil {
                completionHandler(nil, httpResponse, error)
            }
            else {
                completionHandler(data, httpResponse, nil)
            }
        })
        dataTask?.resume()
    }
    
    func sendUniqueRequest(_ method:HTTPMethod,
                           url:String,
                           param: [String : Any]?,
                           headers: [String : String]?,
                           withCompletion completionHandler: @escaping (_ data: Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void)  {
        
        let request = self.createRequest(method, URLString: url, parameters: param, headers: headers)
        print("===================================================")
        print("Request URL: \(request.url?.absoluteString ?? "") \nMethod: \(request.httpMethod ?? "None") \nHeaders: \(request.allHTTPHeaderFields?.description ?? "None") \nParams: \(param?.description ?? "None")")
        print("===================================================")
        self.uniqueDataTask?.cancel()
        self.uniqueDataTask = defaultSession.dataTask(with: request, completionHandler: {(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void in
            let httpResponse = response as? HTTPURLResponse
            if error != nil {
                completionHandler(nil, httpResponse, error)
            }
            else {
                completionHandler(data, httpResponse, nil)
            }
            self.uniqueDataTask = nil
        })
        self.uniqueDataTask?.resume()
    }
}

private extension String {
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}

private extension Dictionary {
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            var percentEscapedValue = ""
            var returnedValue = ""
            if let str = (value as? String) {
                percentEscapedValue = str.stringByAddingPercentEncodingForURLQueryValue()!
                returnedValue =  "\(percentEscapedKey)=\(percentEscapedValue)"
            }
            else if  let array = (value as? [String]) {
                var count = 0
                array.forEach({ (arrayValue) in
                    if 0 != count {
                        returnedValue += "&"
                    }
                    percentEscapedValue = arrayValue.stringByAddingPercentEncodingForURLQueryValue()!
                    returnedValue +=  "\(percentEscapedKey)[]=\(percentEscapedValue)"
                    count += 1
                })
            }
            else if  let integer = (value as? Int) {
                returnedValue =  "\(percentEscapedKey)=\(integer)"
            }
            else if  let double = (value as? Double) {
                returnedValue =  "\(percentEscapedKey)=\(double)"
            }
            else if  let bool = (value as? Bool) {
                returnedValue =  "\(percentEscapedKey)=\(bool)"
            }
            else {
                assert(false, "Wrong query param. \(value)")
            }
            return returnedValue
        }
        
        return parameterArray.joined(separator: "&")
    }
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

extension String {
    var url:URL?{
        return URL(string: self)
    }
}
