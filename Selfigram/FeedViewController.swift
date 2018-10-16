//
//  FeedViewController.swift
//  Selfigram
//
//  Created by Eventbase on 2018-10-10.
//  Copyright © 2018 Eventbase. All rights reserved.
///Users/eventbase/Desktop/Lighthouse/Selfigram/Selfigram/ProfileViewController.swift

import UIKit

class FeedViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=a65a055c2d05b9a374bf59f374c1a239&tags=cat")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            
            // convert Data to JSON
            if let jsonUnformatted = try? JSONSerialization.jsonObject(with: data!, options: []) {
                let json = jsonUnformatted as? [String : AnyObject]
                let photosDictionary = json?["photos"] as? [String : AnyObject]
                if let photosArray = photosDictionary?["photo"] as? [[String : AnyObject]] {
                    
                    for photo in photosArray {
                        
                        if let farmID = photo["farm"] as? Int,
                            let serverID = photo["server"] as? String,
                            let photoID = photo["id"] as? String,
                            let secret = photo["secret"] as? String {
                        
                            let photoURLString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
                            print(photoURLString)
                            if let photoURL = URL(string: photoURLString) {
                                
                                let me = User(aUsername: "sam", aProfileImage: UIImage(named: "Grumpy-Cat")!)
                                let post = Post(imageURL: photoURL, user: me, comment: "A Flickr Selfie")
                                self.posts.append(post)
                            }
                        }
                    }
                    
                    // We use OperationQueue.main because we need update all UI elements on the main thread.
                    // This is a rule and you will see this again whenever you are updating UI.
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                }
    
            }else{
                print("error with response data")
            }
        })
        
        // this is called to start (or restart, if needed) our task
        task.resume()
        
        print ("outside dataTaskWithURL")
        
        
//        let me = User(aUsername: "danny", aProfileImage: UIImage(named: "Grumpy-Cat")!)
        
//        let post0=Post(image:UIImage(named:"Grumpy-Cat")!, user:me, comment:"Grumpy Cat 0")
//        let post1=Post(image:UIImage(named:"Grumpy-Cat")!, user:me, comment:"Grumpy Cat 1")
//        let post2=Post(image:UIImage(named:"Grumpy-Cat")!, user:me, comment:"Grumpy Cat 2")
//        let post3=Post(image:UIImage(named:"Grumpy-Cat")!, user:me, comment:"Grumpy Cat 3")
//        let post4=Post(image:UIImage(named:"Grumpy-Cat")!, user:me, comment:"Grumpy Cat 4")
//
//        posts = [post0, post1, post2, post3, post4]
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let amount: Int = self.posts.count
        return amount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! SelfieCell
        let post = self.posts[indexPath.row]
        
        // I've added this line to prevent flickering of images
        // We are inside the cellForRowAtIndexPath method that gets called everything we layout a cell
        // Because we are reusing "postCell" cells, a reused cell might have an image already set on it.
        // This always resets the image to blank, waits for the image to download, and then sets it
        cell.selfieImageView.image = nil
        
        let task = URLSession.shared.downloadTask(with: post.imageURL) { (url, response, error) -> Void in
            
            if let imageURL = url, let imageData = try? Data(contentsOf: imageURL) {
                OperationQueue.main.addOperation {
                    
                    cell.selfieImageView.image = UIImage(data: imageData)
                }
            }
        }
        
        task.resume()
        cell.usernameLabel.text = post.user.username
        cell.commentLabel.text = post.comment
        
        return cell
    }
   
    @IBAction func cameraButtonPressed(_ sender: Any) {
        // 1: Create an ImagePickerController
        let pickerController = UIImagePickerController()
        
        // 2: Self in this line refers to this View Controller
        //    Setting the Delegate Property means you want to receive a message
        //    from pickerController when a specific event is triggered.
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1 {
            // 3. We check if we are running on a Simulator
            //    If so, we pick a photo from the simulator’s Photo Library
            // We need to do this because the simulator does not have a camera
            pickerController.sourceType = .photoLibrary
        } else {
            // 4. We check if we are running on an iPhone or iPad (ie: not a simulator)
            //    If so, we open up the pickerController's Camera (Front Camera, for selfies!)
            pickerController.sourceType = .camera
            pickerController.cameraDevice = .front
            pickerController.cameraCaptureMode = .photo
        }
        
        // Preset the pickerController on screen
        self.present(pickerController, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 1. When the delegate method is returned, it passes along a dictionary called info.
        //    This dictionary contains multiple things that maybe useful to us.
        //    We are getting an image from the UIImagePickerControllerOriginalImage key in that dictionary
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            //2. To our imageView, we set the image property to be the image the user has chosen
            let me = User(aUsername: "Liam", aProfileImage: UIImage(named: "Grumpy-Cat")!)
//            let post = Post(image: image, user: me, comment: "My Selfie")
            
            //3. Add post to our posts array
            //    Adds it to the very top of our array
//            posts.insert(post, at: 0)
        }
        
        //4. We remember to dismiss the Image Picker from our screen.
        dismiss(animated: true, completion: nil)
        
        //5. Now that we have added a post, reload our table
        tableView.reloadData()
    }

}
