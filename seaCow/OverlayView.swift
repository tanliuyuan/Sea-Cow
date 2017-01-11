import Foundation
import UIKit

enum OverlayViewMode : Int {
    case overlayViewLeft
    case overlayViewRight
}

class OverlayView: UIView {
    
    var mode: OverlayViewMode
    //var imageView: UIImageView
    
    override init(frame:CGRect) {
        mode = OverlayViewMode.overlayViewLeft
        //imageView = UIImageView()
        super.init(frame:frame)
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.red
        //imageView = UIImageView(image: UIImage(named: "noButton"))
        //self.addSubview(imageView)
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func setMode(_ mode: OverlayViewMode) {
        if mode == OverlayViewMode.overlayViewLeft {
            self.backgroundColor = UIColor.red
            //imageView.image = UIImage(named: "noButton")
        } else {
            self.backgroundColor = UIColor.green
           //imageView.image = UIImage(named: "yesButton")
        }
    }
    
    /*override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRectMake(50, 50, 100, 100)
        imageView.backgroundColor = UIColor(red: 72/255, green: 145/255, blue: 206/255, alpha: 1)
    }*/
    
}
