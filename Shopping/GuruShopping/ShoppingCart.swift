//
//  CartView.swift
//  GuruShopping
//
//  Created by Guru Moorthy on 14/10/16.
//  Copyright © 2016 Gurumoorthy. All rights reserved.
//

import Foundation
import UIKit

class ShoppingCart: UIViewController, UITableViewDelegate {
   

    @IBOutlet var cartTotal: UILabel!
    @IBOutlet var TitleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
   
    
    @IBOutlet var CurrencyPicker: UIPickerView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TitleLabel.text = "Thank you for shopping with us!"
        let formatter = NSNumberFormatter()
        formatter.positiveFormat = "$0.00"
        self.cartTotal.text = formatter.stringFromNumber(Cart.sharedInstance.cartTotal)
        self.navigationItem.title = "Your Cart"

         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShoppingCart.methodOfReceivedNotification(_:)), name:"newCartTotal", object: nil)
        
    }
   
    override func viewDidAppear(animated: Bool) {
        Cart.sharedInstance.calculateTotal()
      tableView.reloadData()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func methodOfReceivedNotification(notification: NSNotification){
        let formatter = NSNumberFormatter()
        formatter.positiveFormat = "$0.00"
        let priceString = formatter.stringFromNumber(Cart.sharedInstance.cartTotal)!+":"+Cart.sharedInstance.currency
         dispatch_async(dispatch_get_main_queue()) {
        self.cartTotal.text = priceString
        }
    
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
            return Cart.sharedInstance.myCart.count
       
        
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cartItem : NSDictionary
        let cell = tableView.dequeueReusableCellWithIdentifier("cartcell", forIndexPath: indexPath) as? CartTableCell
        
        
        
        cartItem = Cart.sharedInstance.myCart[indexPath.row] as! NSDictionary
        let theItem : Product = cartItem["item"] as! Product
        let itemCount : Int = cartItem["count"] as! Int
        
        cell?.item.text = theItem.title
        
        
        let formatter = NSNumberFormatter()
        formatter.positiveFormat = "0"
        cell?.count.text = formatter.stringFromNumber(itemCount)
        
       
        formatter.positiveFormat = "$0.00"
        cell?.price.text = formatter.stringFromNumber(theItem.price!.decimalNumberByMultiplyingBy(NSDecimalNumber.init(float: Cart.sharedInstance.cartConversion)).decimalNumberByMultiplyingBy(NSDecimalNumber.init(integer: itemCount)))
      
        
        
        return cell!
    }
     func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
       
        
        let cartItem : NSDictionary
       
        
        
        
        cartItem = Cart.sharedInstance.myCart[indexPath.row] as! NSDictionary
        
        
        let more = UITableViewRowAction(style: .Normal, title: "    ") { action, index in
            print("Buy Button Clicked")
            Cart.sharedInstance.removeItemFromCart(cartItem)
            tableView.reloadData()
            
            
            
        }
        more.title = "Remove"
        more.backgroundColor = UIColor.redColor()
        
        return [more]
        
    }
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        var message = ""
        if(Cart.sharedInstance.myCart.count == 0){
            message = "Your cart is empty"
        }
        return message
    }
    
    
}
