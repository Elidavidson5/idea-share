//
//  Tweet.swift
//  shareidea
//
//  Created by Eli Davidson on 9/11/18.
//  Copyright © 2018 Eli Davidson. All rights reserved.
//

import Foundation
import FirebaseDatabase



struct Tweet{
    let key: String!
    let idea:String!
    let UserAdded: String!
    let itemReference:DatabaseReference?
    
    init(idea: String, UserAdded:String, key:String = ""){
        self.key = key
        self.idea = idea
        self.UserAdded = UserAdded
        self.itemReference = nil
    }
    
    func toAnyObject() -> [AnyHashable : Any]{
    
    
        return ["ideas":idea, "Ideas-User": UserAdded]
    
    }
    
    
    init (snapshot: DataSnapshot){
        key = snapshot.key
        itemReference = snapshot.ref
        
       if let ideaContent = snapshot.value! as? NSDictionary, let feedidea = ideaContent["Ideas"] as? String{
            idea = feedidea
            
       }else{
        idea = ""
        }
        
        if let Useradd = snapshot.value! as? NSDictionary, let feeduser = Useradd["Ideas-USer"] as? String{
        UserAdded = feeduser
            
        }else{
            UserAdded = ""
        }
       
    }

}
