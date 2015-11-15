//
//  HomeViewController.swift
//  Trump
//
//  Created by Cole on 11/14/15.
//  Copyright © 2015 colehudson. All rights reserved.
//

import UIKit
import AVFoundation
import Fabric
import TwitterKit

class HomeViewController: UIViewController
{
    @IBOutlet var startButton: TWTRLogInButton!
    @IBOutlet var label: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func startButtonPressed(sender: TWTRLogInButton)
    {
        // Swift
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
                self.performSegueWithIdentifier("login", sender: self)
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
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
