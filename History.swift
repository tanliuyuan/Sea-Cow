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
        allArticles.append(ReadArticle(withTitle: article.title, withUrl: article.url))
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
            let history = NSKeyedUnarchiver.unarchiveObject(with: data) as! History
            allArticles = history.allArticles
            print("History Loaded")
            return true
        }
        return false
    }

    //returns true if it exists
    func checkIfExists(_ articleTitle: String) -> Bool {
        for article in allArticles {
          //print(articleTitle)
            if(articleTitle == article.title) {
                //print("Article already read")
                return true
            }
        }
        return false
    }
}
