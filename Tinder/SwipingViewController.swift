//
//  SwipingViewController.swift
//  Tinder
//
//  Created by Marco on 10/10/15.
//  Copyright © 2015 Marco. All rights reserved.
//

import UIKit

class SwipingViewController: UIViewController {

    @IBOutlet weak var imageUser: UIImageView!
    
    @IBOutlet weak var labelInfo: UILabel!
    
    var displayedUserId = ""
    
    var xFromCenter : CGFloat = 0
    
    func wasDragged (gesture: UIPanGestureRecognizer) {
        
        // retorna o movimento que foi feito
        let translation = gesture.translationInView (self.view)
        
        // é o gesture que foi passado por parâmetro. no caso, a view será a própria
        // label
        let label = gesture.view!
        
        xFromCenter += translation.x
        
        let scale = min (100 / abs (xFromCenter), 1)
        
        label.center = CGPoint (x: label.center.x + translation.x, y: label.center.y + translation.y)
        
        // zera novamente a translação para que não seja usado o valor acumulado feito
        // anteriormente
        gesture.setTranslation (CGPointZero, inView: self.view)
        
        // rotaciona em radianos (1 rad = 60 graus aproximadamente)
        var rotation : CGAffineTransform = CGAffineTransformMakeRotation (xFromCenter / 200)
        
        var stretch : CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        // quando o usuário solta o objeto, os valores são resetados
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 100 {
                acceptedOrRejected = "rejected"
            
            } else if label.center.x > self.view.bounds.width - 100 {
                acceptedOrRejected = "accepted"
            }

            if acceptedOrRejected != "" {
                PFUser.currentUser()?.addUniqueObjectsFromArray ([displayedUserId], forKey: acceptedOrRejected)
                
                do {
                    try PFUser.currentUser ()?.save ()
                    
                } catch {
                    print ("erro ao salvar")
                }
      
            }
            
            label.center = CGPointMake (self.view.bounds.width / 2, self.view.bounds.height / 2)
            
            xFromCenter = 0
            
            rotation = CGAffineTransformMakeRotation (0)
            
            stretch = CGAffineTransformScale (rotation, 1, 1)
            
            label.transform = stretch
            
            updateImage ()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UIPanGestureRecognizer (target: self, action: Selector ("wasDragged:"))
        
        // adiciona o gesture à label
        imageUser.addGestureRecognizer (gesture)
        
        // para o user poder interagir com o usuário
        // para botões, não precisa, mas para labels, sim!
        imageUser.userInteractionEnabled = true
        
        // um ponto com latitude e longitude
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            
            // ver se existe
            if let geoPoint = geoPoint {
                PFUser.currentUser()? ["location"] = geoPoint
                
                do {
                    try PFUser.currentUser ()?.save ()
                    
                } catch {
                    print ("erro ao salvar")
                }

            }
            
        }
        
        updateImage ()

    }

    func updateImage () {
        
        var query = PFUser.query ()!
        
        var interestedIn = "male"
        
        if PFUser.currentUser()! ["interestedInWomen"]! as! Bool == true {
            interestedIn = "female"
        }
        
        var isFemale = true

        if PFUser.currentUser ()! ["gender"]! as! String == "male" {
            isFemale = false
        }

        if let latitude = PFUser.currentUser()? ["location"]?.latitude {
            if let longitude = PFUser.currentUser()? ["location"]?.longitude {
                
                query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint (latitude: latitude - 1, longitude: longitude - 1), toNortheast: PFGeoPoint (latitude: latitude + 1, longitude: longitude + 1))
            }
        }
        
        query.whereKey ("gender", equalTo: interestedIn)
        query.whereKey ("interestedInWomen", equalTo: isFemale)

        var ignoredUsers = [String]()
        
        if let acceptedUsers = PFUser.currentUser()? ["accepted"] {
            
            ignoredUsers += acceptedUsers as! Array
        }
        
        if let rejectedUsers = PFUser.currentUser()? ["rejected"] {
            
            ignoredUsers += rejectedUsers as! Array
        }
        
        query.whereKey ("objectId", notContainedIn: ignoredUsers)
        
        query.limit = 1
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error != nil {
                print (error)
            } else if let objects : [PFObject] = objects! {
                
                for object in objects {
                    
                    // pega o ID do user
                    self.displayedUserId = object.objectId!
                    
                    let imageFile = object ["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        
                        if error != nil {
                            print (error)
                        } else {
                            
                            if let data = imageData {
                                
                                self.imageUser.image = UIImage (data: data)
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueLogout" {
            PFUser.logOut ()
        }
    
    }
}







/* ******************************************************************** */




