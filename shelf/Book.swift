//
//  Book.swift
//  shelf
//
//  Created by Ergin Bilgin on 20.11.2018.
//  Copyright © 2018 Ergin Bilgin. All rights reserved.
//

import Foundation
import UIKit

class Book {
    var name: String
    var author: String
    var isbn: String
    var pages: Int
    var description: String
    var cover: UIImage
    var isFavourite: Bool
    
    init(){
        self.name = ""
        self.author = ""
        self.isbn = ""
        self.pages = 0
        self.description = ""
        self.cover = UIImage()
        self.isFavourite = false
    }
    
    init(name: String,
         author: String,
         isbn: String,
         pages: Int,
         description: String,
         cover: UIImage){
        self.name = name
        self.author = author
        self.isbn = isbn
        self.pages = pages
        self.description = description
        self.cover = cover
        self.isFavourite = false
    }
    
    
    
    
    
}
