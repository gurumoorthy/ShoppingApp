//
//  ShoppingTable.swift
//  GuruShopping
//
//  Created by Guru Moorthy on 14/10/16.
//  Copyright © 2016 Gurumoorthy. All rights reserved.
//

import UIKit
import CoreData



class ShoppingTable: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
     @IBOutlet weak var baner: BannerView!
    @IBOutlet weak var tableView: UITableView!
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
    var filteredProducts : NSMutableArray = []
    var resultSearchController : UISearchController!
    var products : NSArray  = []
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        //at this step, you download images from a URL or local directory
        let imageName = ["bnr1","bnr2","bnr3","bnr5"]
        
        //you create array of type UIImage
        var arrayImages = [UIImage]()
        for i in 0 ... imageName.count-1
        {
            arrayImages.append(UIImage(named: imageName[i])!)
        }
        
        //instance the class BannerView
        baner.createBanner(arrayImages, widthScreen: UIScreen.mainScreen().bounds.width)
        
    
        
        self.resultSearchController = ({
            
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.Default
            controller.searchBar.barTintColor = UIColor.whiteColor()
            controller.searchBar.backgroundColor = UIColor.clearColor()
            self.tableView.tableHeaderView = controller.searchBar
            
            
            return controller
            
            
        })()
        self.resultSearchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = false
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShoppingTable.loadedSampleData(_:)), name:"SampleDataLoaded", object: nil)
        self.navigationItem.title = "Shopping"
       loadFromCoreData()
        
    }
    
    func loadedSampleData(notification: NSNotification){
        print("recieved notification")
    loadFromCoreData()
        self.tableView.reloadData()
    }

    
    
    func loadTestData(){
        SampleData().loadSampleData();
    }
    
    func loadFromCoreData(){
         let managedContext = appDelegate.managedObjectContext
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
            loadTestData()
        }
        if(results?.count==0){
            loadTestData()
        }
        self.products = results! as NSArray
        self.tableView.reloadData()
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if((self.resultSearchController) != nil){
        if (self.resultSearchController.active)
        {
            return self.filteredProducts.count
        }
        else
        {
            return self.products.count
        }
        }
        else{
            return self.products.count
        }
        
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let theItem : Product
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? ShoppingTableCell
        
        
        if (self.resultSearchController.active)
        {
            theItem = filteredProducts[indexPath.row] as! Product
        }
        else
        {
            
            theItem = products[indexPath.row] as! Product
            
        }
        
        cell?.title.text = theItem.title
        
        let formatter = NSNumberFormatter()
        formatter.positiveFormat = "$0.00"
        cell?.price.text = formatter.stringFromNumber(theItem.price!.decimalNumberByMultiplyingBy(NSDecimalNumber.init(float: Cart.sharedInstance.cartConversion)))!+":"+Cart.sharedInstance.currency
        cell?.unit.text = theItem.unit
        
        
        return cell!
    }
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let theItem : Product
        
        if (self.resultSearchController.active)
        {
            theItem = filteredProducts[indexPath.row] as! Product
        }
        else
        {
            
            theItem = products[indexPath.row] as! Product
            
        }
        purchaseItem(theItem)
    }
    
     func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let theItem : Product
        
        if (self.resultSearchController.active)
        {
            theItem = filteredProducts[indexPath.row] as! Product
        }
        else
        {
            
            theItem = products[indexPath.row] as! Product
            
        }
        
        
        let buy1 = UITableViewRowAction(style: .Normal, title: "    ") { action, index in
            print("Buy Button Clicked")
           
            Cart.sharedInstance.addToCart(theItem, count: 1)
            tableView.reloadData()
            
        }
        buy1.title = "Buy 1"
        buy1.backgroundColor = UIColor.greenColor()
        
        let buy5 = UITableViewRowAction(style: .Normal, title: "    ") { action, index in
            print("Buy Button Clicked")
            
            Cart.sharedInstance.addToCart(theItem, count: 5)
            tableView.reloadData()
            
        }
        buy5.title = "Buy 5"
        buy5.backgroundColor = UIColor.redColor()
        
        return [buy1, buy5]
        
    }
     func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        var message = ""
        if(self.products.count == 0){
            message = "Loading sample data"
           loadTestData()
        }
        return message
    }

    
    
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.filteredProducts = []
        
        
        let searchTxt = searchController.searchBar.text!.lowercaseString
        
        let foundItems = products.filter {
            let foundItem = $0 as! Product
            let title = foundItem.title
            
            if (searchTxt.isEmpty){
                return true
            }
                
            else if title!.lowercaseString.rangeOfString(searchTxt) != nil {
                return true
            }
                
            else{
                return false
            }
            
        }
        
        for item in foundItems{
            self.filteredProducts.addObject(item)
        }
        
        
        self.tableView.reloadData()
    }
    
    deinit {
        self.resultSearchController.view.removeFromSuperview()
    }
    
    func purchaseItem(item : Product){
        let message = String(format: "How Many %@s of %@", item.unit!, item.title!)
        let alert = UIAlertController(title: message, message: "", preferredStyle: .Alert)
        
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
            textField.keyboardType = UIKeyboardType.NumberPad
        })
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            
            let count = Int(textField.text!)
            Cart.sharedInstance.addToCart(item, count: count!)
            print("Added Item to Cart")
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .Default, handler: { (action) -> Void in
          
        }))
        alert.view.setNeedsLayout()
       self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
