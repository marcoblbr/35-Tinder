//
//  ViewController.swift
//  Tinder
//
//  Created by Marco Linhares on 8/22/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonFacebookLogin(sender: AnyObject) {
        
        // permissões que serão pedidas pro Facebook
        // outras permissões simples: "email", "likes"
        let permissions = ["public_profile", "email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions (permissions) {

            (user: PFUser?, error: NSError?) -> Void in
            
            if let error = error {
                print (error)
            } else {
                if let user = user {
                    
                    // significa que ele está logado
                    if let interestedInWomen = user ["interestedInWomen"] {
                        self.performSegueWithIdentifier ("segueLogUserIn", sender: self)
                    } else {
                        self.performSegueWithIdentifier ("segueSigninScreen", sender: self)
                    }
                    
                    if user.isNew {
                        print ("User signed up and logged in through Facebook!")
                    } else {
                        print ("User logged in through Facebook!")
                    }
                    
                } else {
                    print ("Uh oh. The user cancelled the Facebook login.")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        // Push notifications
//        var push = PFPush ()
//
//        push.setMessage ("This is a test")
//
//        push.sendPushInBackgroundWithBlock () {
//            (success: Bool , error: NSError?) -> Void in
//            
//            if success == true {
//                println ("The push campaign has been created.");
//            } else if error!.code == 112 {
//                println ("Could not send push. Push is misconfigured: \(error!.description).");
//            } else {
//                println("Error sending push: \(error!.description).");
//            }
//            
//        }
        
    }
    
    override func viewDidAppear (animated: Bool) {
    
        // caso já esteja logado, avança direto para a próxima tela
        if let username = PFUser.currentUser ()!.username {
            
            // significa que ele está logado
            if let interestedInWomen = PFUser.currentUser ()!["interestedInWomen"] {
                self.performSegueWithIdentifier ("segueLogUserIn", sender: self)
            } else {
                self.performSegueWithIdentifier ("segueSigninScreen", sender: self)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

