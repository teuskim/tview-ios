//
//  Review.swift
//  Tview
//
//  Created by daclouds on 2015. 8. 11..
//
//

import UIKit

class Review {
    
    var objectId: String
    var comment: String
    var author: String
    
    init?(objectId: String, comment: String, author: String) {
        self.objectId = objectId
        self.comment = comment
        self.author = author
    }
}
