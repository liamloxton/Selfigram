//
//  Post.swift
//  Selfigram
//
//  Created by Eventbase on 2018-10-10.
//  Copyright © 2018 Eventbase. All rights reserved.
//

import Foundation
import UIKit

class Post {
    let imageURL:URL
    let user:User
    let comment:String
   
    init(imageURL:URL, user:User, comment:String){
        self.imageURL = imageURL
        self.user = user
        self.comment = comment
    }
}
