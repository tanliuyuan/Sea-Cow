import UIKit

class ReadArticle: NSObject, NSCoding {
   
    var title: String!
    var url: String!
    // MARK: NSCoding
    
    override init() {}
    
    required init(title2: String, url2: String) {
        self.title = title2
        self.url = url2
    }
    
    required init(coder decoder: NSCoder) {
        self.title = decoder.decodeObject(forKey: "title") as! String?
        self.url = decoder.decodeObject(forKey: "url") as! String?
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.url, forKey: "url")
    }
    


}
