import UIKit

class History: NSObject {
    var allArticles: [ReadArticle] = []
    
    override init() {
        print("History initialized")
    }
    
    required init(coder decoder: NSCoder) {
        self.allArticles = decoder.decodeObject(forKey: "allArticles") as! [ReadArticle]
    }
    
    func encodeWithCoder(_ coder: NSCoder) {
        coder.encode(self.allArticles, forKey: "allArticles")
    }
    
    func addArticle(_ article: ArticleData) {
        allArticles.append(ReadArticle(title2: article.title, url2: article.url))
    }
    
    func save() {
        print("trying to save")
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        print("data created, trying to write")
        UserDefaults.standard.set(data, forKey: "history")
        print("success")
    }
    
    func load() -> Bool {
        if let data = UserDefaults.standard.object(forKey: "history") as? Data {
            let temp = NSKeyedUnarchiver.unarchiveObject(with: data) as! History
            allArticles = temp.allArticles
            print("History Loaded")
            return true
        }
        return false
    }

    //returns true if it exists
    func checkIfExists(_ articleName: String) -> Bool {
        for article in allArticles {
          //  println(articleName)
            if(articleName == article.title) {
                //println("Article already read")
                return true
            }
        }
        return false
    }
}
