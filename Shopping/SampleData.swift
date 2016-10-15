//
//  SampleData.swift
//  GuruShopping
//
//  Created by Guru Moorthy on 14/10/16.
//  Copyright © 2016 Gurumoorthy. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class SampleData: NSObject {
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    
    public func loadSampleData(){
        
         let managedContext = appDelegate.managedObjectContext
        
        
        //clear out any old entries 
        
        let request = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Product", inManagedObjectContext: managedContext)
        request.entity = entity
        
        // var error: NSError? = nil
        let results: [AnyObject]?
        do {
            results = try managedContext.executeFetchRequest(request)
        } catch let error1 as NSError {
            print(error1)
            results = nil
        }

        
        for product: AnyObject in results!
        {
            managedContext.deleteObject(product as! NSManagedObject)
        }

        appDelegate.saveContext()
        
        
        //load items from included json file
        if let path = NSBundle.mainBundle().pathForResource("SampleData", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    
                    
                    
                    if let items = jsonObj["items"].array {
                        for item in items {
                          let newProduct = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext) as? Product
                            if let title = item["title"].string {
                            newProduct?.title = title
                            }
                            if let priceString = item["price"].number {
                                
                            newProduct?.price = NSDecimalNumber.init(decimal: priceString.decimalValue)
                            }
                            if let unit = item["unit"].string {
                                newProduct?.unit = unit
                            }
                            appDelegate.saveContext()
                            
                        }
                        print("Loaded Sample data from file to Core Data")
                        NSNotificationCenter.defaultCenter().postNotificationName("SampleDataLoaded", object: nil)
                    }
                    
                } else {
                    print("could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        
        
       
        
       
    }
    
    

}
