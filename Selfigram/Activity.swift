//
//  Activity.swift
//  Selfigram
//
//  Created by Eventbase on 2018-10-31.
//  Copyright © 2018 Eventbase. All rights reserved.
//

import Foundation
import Parse

class Activity:PFObject, PFSubclassing {
    
    @NSManaged var type:String
    @NSManaged var post:Post
    @NSManaged var user:PFUser
    
    static func parseClassName() -> String {
        return "Activity"
    }
    
    convenience init(type:String, post:Post, user:PFUser){
        self.init()
        self.type = type
        self.post = post
        self.user = user
    }
    
}

