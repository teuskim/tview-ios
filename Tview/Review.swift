//
//  Review.swift
//  Tview
//
//  Created by daclouds on 2015. 8. 11..
//
//

import UIKit

class Review {
    var comment: String
    var author: String
    
    init?(comment: String, author: String) {
        self.comment = comment
        self.author = author
    }
}
