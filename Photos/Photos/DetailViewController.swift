//
//  DetailViewController.swift
//  Photos
//
//  Created by Artem Yudin on 11/14/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var user: String!
    var like: String!
    var img: UIImage!
    var url: String!
    var imageView: UIImageView!
    var textLabel: UILabel!
    var textLabelLikes: UILabel!
    var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadHQ(self.url, callback: self.resetImage)
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let viewWhite = UIView()
        viewWhite.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        viewWhite.backgroundColor = UIColor.whiteColor()
        view.addSubview(viewWhite)
        imageView = UIImageView(image: img)
        imageView.frame = CGRect(x: 0, y: 55, width: screenSize.width, height: screenSize.width)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        view.addSubview(imageView)
        let textFrame = CGRect(x: 2, y: 55 + screenSize.width + 10, width: screenSize.width/1.6, height: 20)
        textLabel = UILabel(frame: textFrame)
        textLabel.textColor = UIColor.blueColor()
        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.textAlignment = .Left
        textLabel.text = "User: " + self.user
        view.addSubview(textLabel)
        let textFrame2 = CGRect(x: screenSize.width - screenSize.width/3 - 2, y: screenSize.width + 10 + 55, width: screenSize.width/3, height: 20)
        textLabelLikes = UILabel(frame: textFrame2)
        textLabelLikes.textColor = UIColor.purpleColor()
        textLabelLikes.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabelLikes.textAlignment = .Right
        textLabelLikes.text = "Likes: " + self.like
        view.addSubview(textLabelLikes)
        self.button = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRect(x: screenSize.width - screenSize.width/5, y: screenSize.width + 90, width: 40, height: 20)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Like", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func buttonAction(sender:UIButton!) {
        if (self.button.backgroundColor == UIColor.greenColor()) {
            self.button.backgroundColor = UIColor.redColor()
        } else {
            self.button.backgroundColor = UIColor.greenColor()
        }
    }
    
    func resetImage(img: UIImage) {
        self.imageView.image = img
        self.imageView.setNeedsDisplay()
    }
    
    func loadHQ(url: String, callback: (UIImage) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                callback(UIImage.init(data: data!)!)
            } else {
                print(error)
            }
        }
        task.resume()
    }
    
}
