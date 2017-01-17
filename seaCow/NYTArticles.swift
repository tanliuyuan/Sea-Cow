import UIKit
import Foundation

class NYTArticles: NSObject {
    var articles = Array<ArticleData>()
    var history: History = History()
    
    func load(_ fromURLString: String, loadCompletionHandler: @escaping (NYTArticles, String?) -> Void) {
        _ = history.load()
        if let url = URL(string: fromURLString) {
            let urlRequest = URLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    DispatchQueue.main.async(execute: {
                        loadCompletionHandler(self, error!.localizedDescription)
                    })
                } else {
                    if data != nil {
                        self.parse(data!, parseCompletionHandler: loadCompletionHandler)
                    } else {
                        print("Error: API call returns nil")
                    }
                }
            })
            task.resume()
        } else {
            DispatchQueue.main.async(execute: {
                loadCompletionHandler(self, "Invalid URL")
            })
        }
    }
    
    func parse(_ jsonData: Data, parseCompletionHandler: @escaping (NYTArticles, String?) -> Void) {
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: [])
            //print(jsonResult)
            if let jsonDictionary = jsonResult as? [String: Any] {
                if let status = jsonDictionary["status"] as? String {
                    if status == "OK" {
                        if let results = jsonDictionary["results"] as? [NSDictionary]{
                            for result in results {
                                guard let resultUrl = result["url"] as? String,
                                    let resultTitle = result["title"] as? String,
                                    let resultSection = result["section"] as? String,
                                    let resultMultimedia = result["multimedia"] as? [NSDictionary]
                                else {
                                    print("Error fetching results")
                                    continue
                                    //##############################//
                                    //###TODO: add error handling###//
                                    //##############################//
                                }
                                for medium in resultMultimedia {
                                    guard let mediumType = medium["type"] as? String,
                                        mediumType == "image",
                                        let mediumFormat = medium["format"] as? String,
                                        mediumFormat == "superJumbo", // Standard Thumbnail | thumbLarge | Normal | superJumbo
                                        let mediumUrl = medium["url"] as? String
                                    else {
                                        continue
                                        //##############################//
                                        //###TODO: add error handling###//
                                        //##############################//
                                    }
                                    let resultImageUrl = mediumUrl
                                    let article = ArticleData(forTitle: resultTitle, forUrl: resultUrl, forImageUrl: resultImageUrl, forSection: resultSection)
                                    let exists = history.checkIfExists(article.title)
                                    if !exists {
                                        articles.append(article)
                                    } else {
                                        print("Article exists in history")
                                    }
                                }
                            }
                        } else {
                            print("Failed to convert jsonDictionary[\"results\"] as [NSDictionary]")
                        }
                    } else {
                        // What if status != "OK"???
                        print("Status not OK")
                    }
                }
            }
            DispatchQueue.main.async(execute: {
                parseCompletionHandler(self, nil)
            })
        } catch {
            print("Error deserializing JSON: \(error)")
        }
    }
    //#######################################################################################//
    //###TODO: rewrite the parse function to keep up with the latest NYT API and Swift 3.0###//
    //#######################################################################################//

    /*func parse(_ jsonData: Data, parseCompletionHandler: @escaping (NYTArticles, String?) -> Void) {
        var jsonError: NSError?
        
        if let jsonResult = JSONSerialization.JSONObjectWithData(jsonData, options: JSONSerialization.ReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary {
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
                        DispatchQueue.main.async(execute: {
                            parseCompletionHandler(self, nil)
                        })
                    }
                }
            } else {
                if let unwrappedError = jsonError {
                    DispatchQueue.main.async(execute: {
                        parseCompletionHandler(self, "\(unwrappedError)")
                    })
                }
            }
        }
    }*/
}
