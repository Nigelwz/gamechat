//
//  extension.swift
//  gamechat
//
//  Created by eric on 2019/2/2.
//  Copyright © 2019 eric. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    func loadImageUsingCacheUrlString(urlString: String){
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as?
            UIImage{
            self.image = cachedImage
            return
        }
        
        
        let url = NSURL(string: urlString)
        
        
        URLSession.shared.dataTask(with: url! as URL, completionHandler: {(data,response,error) in
            
            if error != nil{
                print(error as Any)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                //self.image = UIImage(data: data!)
                //self.tableView.reloadData()
                //cell.imageView?.image = UIImage(data:data!)
            }
            
        }).resume()
    }
}
