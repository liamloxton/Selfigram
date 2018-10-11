//
//  User.swift
//  Selfigram
//
//  Created by Eventbase on 2018-10-10.
//  Copyright © 2018 Eventbase. All rights reserved.
//

import Foundation
import UIKit

class User {
    let username:String
    let profileImage:UIImage
    
    init(aUsername:String, aProfileImage:UIImage){
        username = aUsername
        profileImage = aProfileImage
    }
}

