//
//  CurencyConversion.swift
//  GuruShopping
//
//  Created by Guru Moorthy on 14/10/16.
//  Copyright © 2016 Gurumoorthy. All rights reserved.
//

import Foundation



public typealias ServiceResponse = (JSON, NSError?) -> Void


public class CurencyConversion: NSObject {
    
    var url = "http://apilayer.net/api/live?access_key=3a2192565e7aedfb8af93e4a2f035d95&currencies=USD,AUD,CAD,PLN,MXN,EUR&format=1"
    
    public var currencyChoices = ["USD","AUD","CAD","PLN","MXN","EUR"]
   
    
    public class var sharedInstance : CurencyConversion {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : CurencyConversion? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = CurencyConversion()
        }
        
        return Static.instance!
    }




    public func getConversionRate(format: String){
        
        Cart.sharedInstance.currency = format
        let formatIneed = "USD"+format
        
        self.makeHTTPGetRequest(url, onCompletion: {json, err in
           let returnData = json.dictionary
            let quoteDict = returnData!["quotes"]!.dictionary
            
            print(quoteDict![formatIneed])
            Cart.sharedInstance.cartConversion = (quoteDict![formatIneed]?.floatValue)!
            Cart.sharedInstance.calculateTotal()
        
        })
    
    }




 func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
    
    
    let request = NSMutableURLRequest(URL: NSURL(string: path)!)
    
    let session = NSURLSession.sharedSession()
    
    let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        if((data) != nil){
            let json:JSON = JSON(data: data!)
            onCompletion(json, error)
        }
    })
    task.resume()
}

}
