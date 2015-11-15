//
//  PhotosCollectionViewController.swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    var textLabel: UILabel!
    var textLabelLikes: UILabel!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - 20))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)
        
        let textFrame = CGRect(x: 2, y: 146, width: frame.size.width - frame.size.width/4.4, height: frame.size.height/4)
        textLabel = UILabel(frame: textFrame)
        textLabel.textColor = UIColor.blueColor()
        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.textAlignment = .Left
        contentView.addSubview(textLabel)
        
        let textFrame2 = CGRect(x: 120, y: 146, width: frame.size.width/4.4, height: frame.size.height/4)
        textLabelLikes = UILabel(frame: textFrame2)
        textLabelLikes.textColor = UIColor.purpleColor()
        textLabelLikes.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabelLikes.textAlignment = .Right
        contentView.addSubview(textLabelLikes)
    }
}


class PhotosCollectionViewController: UICollectionViewController {
    var photos: [Photo]!
    var pics: [UIImage]!
    var completionCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let api = InstagramAPI()
        api.loadPhotos(didLoadPhotos)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 160, height: 180)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.photos != nil {
            return self.photos.count
        } else {
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let next = DetailViewController()
        next.user = self.photos[indexPath.item].username
        next.like = String(self.photos[indexPath.item].likes)
        next.img = self.pics[indexPath.item]
        next.url = self.photos[indexPath.item].urlHQ
        self.navigationController?.pushViewController(next, animated: true)
    }
    

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) ->
        UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        if let items = photos {
            cell.backgroundColor = UIColor.whiteColor()
            let photo = items[indexPath.item]
            cell.textLabel?.text = photo.username
            var like_count: String
            if (photo.likes < 1000) {
                like_count = String(photo.likes)
            } else if (photo.likes < 10000) {
                like_count = String(photo.likes/1000) + "," + String(photo.likes%1000)
            } else if (photo.likes < 1000000) {
                like_count = String(photo.likes/1000) + "k"
            } else {
                like_count = String(photo.likes/1000000) + "M"
            }
            cell.textLabelLikes?.text = like_count
            cell.imageView?.image = self.pics[indexPath.item]
            cell.imageView.setNeedsDisplay()
        }
        return cell
    }
    
    func appendToPhoto(img: UIImage, index: Int) {
        self.completionCount++
        self.pics[index] = img
        if (self.completionCount == self.photos.count) {
            self.collectionView!.reloadData()
            self.collectionView!.reloadData()
        }
    }

    
    /* Creates a session from a photo's url to download data to instantiate a UIImage. 
       It then sets this as the imageView's image. */
    func loadImageForCell(url: String, index: Int, callback: (UIImage, Int) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                callback(UIImage.init(data: data!)!, index)
            } else {
                print(error)
            }
        }
        task.resume()
    }
    
    /* Completion handler for API call. DO NOT CHANGE */
    func didLoadPhotos(photos: [Photo]) {
        self.photos = photos
        self.photos.sortInPlace({ $0.likes > $1.likes })
        self.collectionView!.reloadData()
        self.pics = [UIImage](count: photos.count, repeatedValue: UIImage())
        for (index, photo) in self.photos.enumerate() {
            self.loadImageForCell(photo.url, index: index, callback: self.appendToPhoto)
        }
    }
    
}

