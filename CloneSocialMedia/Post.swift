//
//  Post.swift
//  CloneSocialMedia
//
//  Created by Atalay Aşa on 20/08/2017.
//  Copyright © 2017 Atalay Asa. All rights reserved.
//

import Foundation

class Post {
    private var _caption:String!
    private var _imageUrl: String!
    private var _likes:Int!
    private var _postKey:String!    //Unique olan keyi
    
    
    var caption:String {
        return _caption
    }
    
    var imageUrl:String {
        return _imageUrl
    }
    
    var likes:Int {
        return _likes
    }
    
    var postKey:String {
        return _postKey
    }
    
    //Bu class ile biz bir model oluşturuyoruz bu modelde JSON tipinde firebase den alacağımız Datayı
    //
    
    init(caption:String,imageUrl:String,likes:Int) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postKey:String, postData: Dictionary<String,AnyObject>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
    }
    

    
    
    
    
}
