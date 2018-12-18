//
//  CollectionViewCell.swift
//  shelf
//
//  Created by Ergin Bilgin on 11.12.2018.
//  Copyright © 2018 Ergin Bilgin. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var bookImage: UIImageView!
    
    func displayContent(image: UIImage) {
        bookImage.image = image
    }
    
}
