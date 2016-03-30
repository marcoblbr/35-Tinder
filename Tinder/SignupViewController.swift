//
//  SignupViewController.swift
//  Tinder
//
//  Created by Marco on 9/21/15.
//  Copyright © 2015 Marco. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var imageUser: UIImageView!
    
    @IBOutlet weak var switchInterestedInWomen: UISwitch!
    
    @IBAction func buttonSignup(sender: AnyObject) {
        PFUser.currentUser()! ["interestedInWomen"] = switchInterestedInWomen.on
        
        do {
            try PFUser.currentUser ()?.save ()
        } catch {
            print ("erro ao salvar")
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // criando usuários na mão
        
//        let urlArray = ["http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=1760886",
//            "http://static.comicvine.com/uploads/square_small/0/2617/103863-63963-torongo-leela.JPG",
//            "http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=62956603",
//            "https://itfinspiringwomen.files.wordpress.com/2014/03/scooby-doo-tv-09.jpg",
//            "http://s3.amazonaws.com/readers/2010/12/16/betty-rubble_1.jpg",
//            "http://static.vectorcharacters.net/uploads/2012/08/Cute_Girl_Vector_Character_Preview_Big.jpg"]
//        
//        var counter = 1
//        
//        for url in urlArray {
//            
//            let nsUrl = NSURL (string: url)!
//            
//            if let data = NSData (contentsOfURL: nsUrl) {
//                
//                self.imageUser.image = UIImage (data: data)
//                
//                // save to disk
//                let imageFile : PFFile = PFFile (data: data)
//                
//                var user : PFUser = PFUser ()
//                
//                var username = "user\(counter)"
//                
//                user.username = username
//                user.password = "pass"
//                user ["image"] = imageFile
//                user ["interestedInWomen"] = false
//                user ["gender"] = "female"
//                
//                counter++
//                
//                try! user.signUp()
//            }
//        }
        
        // Do any additional setup after loading the view.
        
        // pega informações do facebook
        // só consegue se a pessoa estiver logada
        let graphRequest = FBSDKGraphRequest (graphPath: "me", parameters: ["fields" : "id, name, gender, email"])
        
        graphRequest.startWithCompletionHandler () {
            
            (connection, result, error) -> Void in
            
            if error != nil {
                print (error)
                
                
            } else if let result = result {
                
                PFUser.currentUser()? ["gender"] = result ["gender"]
                PFUser.currentUser()? ["name"]   = result ["name"]
                PFUser.currentUser()? ["email"]  = result ["email"]
                
                do {
                    try PFUser.currentUser ()?.save ()
                    
                    let userId = result ["id"] as! String
                    
                    let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                    
                    if let facebookPictureUrl = NSURL (string: facebookProfilePictureUrl) {
                        if let data = NSData (contentsOfURL: facebookPictureUrl) {
                            
                            self.imageUser.image = UIImage (data: data)
                            
                            // save to disk
                            let imageFile : PFFile = PFFile (data: data)
                            
                            PFUser.currentUser()! ["image"] = imageFile
                            
                            try PFUser.currentUser()?.save ()
                        }
                    }
                    
                } catch {
                    print ("erro ao salvar")
                }
                
                // outra maneira forçada é o comando abaixo
                // try! PFUser.currentUser ()?.save ()
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
