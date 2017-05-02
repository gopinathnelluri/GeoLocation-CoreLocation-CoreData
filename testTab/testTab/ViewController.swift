//
//  ViewController.swift
//  testTab
//
//  Created by  on 5/2/17.
//  Copyright © 2017 uhcl. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!
    
    @IBOutlet weak var firstname: UITextField!
    
    @IBOutlet weak var lastname: UITextField!
    
    
    @IBOutlet weak var address: UITextView!
    
    @IBAction func add(_ sender: UIButton) {
        let person = Person(context: context)
        person.firstname = firstname.text!
        person.lastname = lastname.text!
        person.address = address.text!
        appDelegate.saveContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        context = appDelegate.persistentContainer.viewContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

