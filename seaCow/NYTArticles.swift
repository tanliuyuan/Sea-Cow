//
//  NYTArticles.swift
//  seaCow
//
//  Created by Liuyuan Tan on 4/21/15.
//  Copyright (c) 2015 Sea Cow. All rights reserved.
//

import UIKit

class NYTArticles: NSObject {
    var articles = Array<ArticleData>()
    var history: History = History()
    
    func load(fromURLString:String, loadCompletionHandler: (NYTArticles, String?) -> Void) {
        history.load()
        if let url = NSURL(string: fromURLString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        loadCompletionHandler(self, error.localizedDescription)
                    })
                } else {
                    self.parse(data, parseCompletionHandler: loadCompletionHandler)
                }
            })
            
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                loadCompletionHandler(self, "Invalid URL")
            })
        }
    }
    
    func parse(jsonData: NSData, parseCompletionHandler: (NYTArticles, String?) -> Void) {
        var jsonError: NSError?
        
        if let jsonResult = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary {
            if (jsonResult.count > 0) {
                if let status = jsonResult["status"] as? NSString {
                    if status == "OK" {
                        if let results = jsonResult["results"] as? [NSDictionary] {
                            //println("Num Results")
                            //println(results.count)
                            for result in results {
                                if let resultUrl = result["url"] as? NSString {
                                    if let resultSection = result["section"] as? NSString {
                                    if let resultTitle = result["title"] as? NSString {
                                        if let media = result["media"] as? [NSDictionary] {
                                            for medium in media {
                                                if let mediumType = medium["type"] as? NSString{
                                                    // look for image to put on card
                                                    if mediumType == "image" {
                                                        if let metadata = medium["media-metadata"] as? [NSDictionary] {
                                                            for data in metadata {
                                                                if let dataFormat = data["format"] as? NSString {
                                                                    // for image on swipe card, look for normal sized image only
                                                                    if dataFormat == "Jumbo" {
                                                                        //im going through this very methodically
                                                                        if let imageUrl = data["url"] as? NSString {
                                                                            //println(resultTitle)
                                                                            var art = ArticleData(forTitle: resultTitle as String, forUrl: resultUrl as String, forImageUrl: imageUrl as String, forSection: resultSection as String)
                                                                            var test = history.checkIfExists(art.title)
                                                                            //println(test)
                                                                            
                                                                            
                                                                            //################################################
                                                                            //comment out the ifs to disable to load blocking
                                                                            if(test == false) {
                                                                                articles.append(art)
                                                                            }
                                                                            
                                                                            //################################################
                                                                            
                                                                            break
                                                                        }
                                                                    } else {
                                                                        continue
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    } else {
                                                        break
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            parseCompletionHandler(self, nil)
                        })
                    }
                }
            } else {
                if let unwrappedError = jsonError {
                    dispatch_async(dispatch_get_main_queue(), {
                        parseCompletionHandler(self, "\(unwrappedError)")
                    })
                }
            }
        }
    }
}