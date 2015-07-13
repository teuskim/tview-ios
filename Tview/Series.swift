//
//  Series.swift
//  Tview
//
//  Created by daclouds on 2015. 7. 13..
//
//

import UIKit

class Series {
    var seriesId: String
    var title: String
    var genreIds: String
    var genreNames: String
    var ratingAverage: Double
    var participant: Int
    var linkUrl: String
    
    init?(seriesId: String, title: String, genreIds: String, genreNames: String, ratingAverage: Double, participant: Int, linkUrl: String) {
        self.seriesId = seriesId
        self.title = title
        self.genreIds = genreIds
        self.genreNames = genreNames
        self.ratingAverage = ratingAverage
        self.participant = participant
        self.linkUrl = linkUrl
    }
}