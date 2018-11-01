//
//  FeedViewController.swift
//  Selfigram
//
//  Created by Eventbase on 2018-10-10.
//  Copyright © 2018 Eventbase. All rights reserved.
// /Users/eventbase/Desktop/Lighthouse/Selfigram/Selfigram/ProfileViewController.swift

import UIKit
import Parse

class FeedViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let query = Post.query() {
            query.order(byDescending: "createdAt")
            query.includeKey("user")
        
            query.findObjectsInBackground(block: { (posts, error) -> Void in
            
                if let posts = posts as? [Post]{
                    self.posts = posts
                    self.tableView.reloadData()
                }
            })
        } 
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let amount: Int = self.posts.count
        return amount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! SelfieCell
        
        let post = self.posts[indexPath.row]
        
        cell.post = post
        
//        let imageFile = post.image
//        imageFile.getDataInBackground(block: {(data, error) -> Void in
//            if let data = data {
//                let image = UIImage(data: data)
//                cell.selfieImageView.image = image
//            }
//        })
//
//        cell.usernameLabel.text = post.user.username
//        cell.commentLabel.text = post.comment
        
        return cell
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        // 1: Create an ImagePickerController
        let pickerController = UIImagePickerController()
        
        
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1 {
            pickerController.sourceType = .photoLibrary
        } else {
            
            pickerController.sourceType = .camera
            pickerController.cameraDevice = .front
            pickerController.cameraCaptureMode = .photo
        }
        
        // Preset the pickerController on screen
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // setting the compression quality to 90%
            if let imageData = image.jpegData(compressionQuality: 0.9),
                let imageFile = PFFile(data: imageData),
                let user = PFUser.current(){
 
                //2. We create a Post object from the image
                let post = Post(image: imageFile, user: user, comment: "A Selfie")
                
                post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        self.posts.insert(post, at: 0)
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.tableView.insertRows(at: [indexPath], with: .automatic)
                    }
                })
            }
        }
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
}
