//
//  ContactsViewController.swift
//  Tinder
//
//  Created by Marco on 10/21/15.
//  Copyright © 2015 Marco. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {

    var emails = [String] ()
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var query = PFUser.query()!
        
        // equalTo não significa "igual a", significa que contém o valor informado
        query.whereKey ("accepted", equalTo: (PFUser.currentUser()!.objectId)!)
        query.whereKey ("objectId", containedIn: PFUser.currentUser()? ["accepted"] as! [String])

        query.findObjectsInBackgroundWithBlock {
        
            (results, error) -> Void in
            
            if let results = results {
                
                for result in results as! [PFUser] {
                    self.emails.append (result ["email"]! as! String)
                    
                    let imageFile = result ["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        
                        if error != nil {
                            print (error)
                        } else {
                            
                            if let data = imageData {
                                
                                self.images.append (UIImage (data: data)!)
                                
                                self.tableView.reloadData()

                            }
                        }
                    }
                }
        
                self.tableView.reloadData()
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return emails.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = emails [indexPath.row]
        
        // significa que a imagem existe
        if images.count > indexPath.row {
            cell.imageView?.image = images [indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = NSURL (string: "mailto:" + emails[indexPath.row])
        
        // para abrir a aplicação do e-mail
        UIApplication.sharedApplication().openURL(url!)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
