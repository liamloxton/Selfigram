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
    let image:UIImage
    let user:User
    let comment:String
   
    init(image:UIImage, user:User, comment:String){
        self.image = image
        self.user = user
        self.comment = comment
    }
}
