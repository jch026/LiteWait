//
//  RestaurantController.swift
//  litewait
//
//  Created by Yizhong Chen on 10/19/18.
//  Copyright © 2018 dumplingNinjas. All rights reserved.
//

import Foundation
import Firebase

class RestaurantController{
    var RestaurantList: Array<Restaurant> = Array()
    var ref:DatabaseReference?
    
    func read() -> Array<Restaurant>{
        //RestaurantList.append()
        return RestaurantList
    }
    
}
