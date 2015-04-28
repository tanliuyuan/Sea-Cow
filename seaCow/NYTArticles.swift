//
//  NYTArticles.swift
//  seaCow
//
//  Created by Liuyuan Tan on 4/21/15.
//  Copyright (c) 2015 Liuyuan Tan. All rights reserved.
//

import UIKit

class NYTArticles: NSObject {
    var articles = Array<ArticleData>()
    
    func load(fromURLString:String, loadCompletionHandler: (NYTArticles, String?) -> Void) {
        println("In nyt load")
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
                    println("Preparing to parse")
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
        println("In parse")
        var jsonError: NSError?
<<<<<<< HEAD
        var i = 0;
=======
        
>>>>>>> origin/master
        if let jsonResult = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary {
            if (jsonResult.count > 0) {
                if let status = jsonResult["status"] as? NSString {
                    if status == "OK" {
<<<<<<< HEAD
                        println("Status = OK")
=======
>>>>>>> origin/master
                        if let results = jsonResult["results"] as? [NSDictionary] {
                            for result in results {
                                if let resultUrl = result["url"] as? NSString {
                                    if let resultTitle = result["title"] as? NSString {
<<<<<<< HEAD
                                        println("Have a title - " + resultTitle.description)
=======
                                        // In case some articles don't have the image we want, make an ArticleData object with title and url first
                                        var articleData = ArticleData(forTitle: resultTitle as String, forUrl: resultUrl as String, forImageUrl: "")
>>>>>>> origin/master
                                        if let media = result["media"] as? [NSDictionary] {
                                            for medium in media {
                                                if let mediumType = medium["type"] as? NSString{
                                                    // look for image to put on card
                                                    if mediumType == "image" {
                                                        if let metadata = medium["media-metadata"] as? [NSDictionary] {
                                                            println(metadata.count)
                                                            for (i = 0; i < metadata.count; i++)  {
                                                                var data = metadata[i]
                                                                if let dataFormat = data["format"] as? NSString {
                                                                    println(dataFormat)
                                                                    // for image on swipe card, look for normal sized image only
                                                                    if dataFormat == "Normal" {
                                                                        if let imageUrl = data["url"] as? NSString {
<<<<<<< HEAD
                                                                            println(imageUrl)
                                                                            articles.append(ArticleData(forTitle: resultTitle as String, forUrl: resultUrl as String, forImageUrl: imageUrl as String))
                                                                            break
                                                                        }
=======
                                                                            articleData.imageUrl = imageUrl as String
                                                                            articles.append(articleData)
                                                                            break
                                                                        }
                                                                    } else {
                                                                        continue
>>>>>>> origin/master
                                                                    }
                                                                    articles.append(articleData)
                                                                }
                                                            }
                                                        }
                                                    } else {
                                                        continue
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
        println("Through parse")
    }
}