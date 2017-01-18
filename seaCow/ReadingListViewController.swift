import UIKit
import TwitterKit
import Fabric

class ReadingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var myTableView: UITableView!
    
    var readingList = NYTArticles()
    var allArticles: [ArticleData]?
    var selectedArticle: ArticleData?
    var listArticles: ReadingList?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.myTableView.reloadData()
        allArticles = listArticles?.getArticles()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allArticles != nil {
            return allArticles!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        if(allArticles!.count > 0) {
            
            //cell.title?.text = readingList.articles[indexPath.row].title
            cell.title?.text = allArticles![indexPath.row].title
            cell.title?.font = UIFont(name: "Gotham Light", size: 18)
            //let url = NSURL(string: readingList.articles[indexPath.row].imageUrl)
            let url = URL(string: allArticles![indexPath.row].imageUrl)
            let data = try? Data(contentsOf: url!)
            
            cell.backgroundImage.image = UIImage(data: data!)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticle = allArticles![indexPath.row]
        performSegue(withIdentifier: "showArticle", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal , title: "Share", handler: { (action: UITableViewRowAction!, indexPath: IndexPath!) in
            
            let composer = TWTRComposer()
            
            composer.setText("Check out this awesome article!\n\n" + self.allArticles![indexPath.row].url + "\n\n#SeaCow")
            composer.setImage(UIImage(named: "fabric"))
            
            composer.show(from: self) { (result) -> Void in
                if (result == TWTRComposerResult.cancelled) {
                    print("Tweet composition cancelled")
                }
                else {
                    print("Sending tweet!")
                }
            }
            
            self.myTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
            return
        })
        
        shareAction.backgroundColor = UIColor.blue
       
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default , title: "Delete", handler: { (action: UITableViewRowAction!, indexPath: IndexPath!) in
            
            self.allArticles?.remove(at: indexPath.row)
            self.listArticles?.removeArticle(indexPath.row)
            self.myTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            self.listArticles!.save()
            return
        })
        
        return [deleteAction, shareAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showArticle"){
        let destinationViewController = segue.destination as! ArticleViewController
        destinationViewController.article = selectedArticle
        }
        
    }
    
    @IBAction func back(_ sender: AnyObject) {
        performSegue(withIdentifier: "returnToCards", sender: self)
    }
    
    @IBAction func returnToReadingList(_ segue: UIStoryboardSegue) {
        
    }
    
    

}
