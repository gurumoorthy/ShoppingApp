//
//  Product+CoreDataProperties.swift
//  GuruShopping
//
//  Created by Guru Moorthy on 14/10/16.
//  Copyright © 2016 Gurumoorthy. All rights reserved.
//

import Foundation
import CoreData

extension Product {

    @NSManaged var title: String?
    @NSManaged var unit: String?
    @NSManaged var price: NSDecimalNumber?
    @NSManaged var desc: String?
    @NSManaged var image: NSData?
    @NSManaged var imageURL: String?

}
