//
//  UserClass.swift
//  Kanito
//
//  Created by Luciano Calderano on 02/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import Foundation

enum UserType: String {
    case None = ""
    case pvt
    case biz
}

class UserClass {
    private let userKey = "UserConfig"
    private let tourKey = "Tour"
    private let userConfig =  UserDefaults.init(suiteName: "userConfig")

    var userProfile:JsonDict {
        get {
            return getUserProfile()
        }
    }
    var userId:Int {
        get {
            return getId()
        }
    }
    var userType:UserType {
        get {
            return getType()
        }
    }
    
    var tourIsComplete:Bool {
        get {
            return UserDefaults.standard.bool(forKey: tourKey)
        }
        set {
            UserDefaults.standard.set(true, forKey: tourKey)
        }
    }

    private func getType () -> UserType {
        let dict = self.getUserProfile()
        switch dict.string("tipologia") {
        case UserType.pvt.rawValue:
            return .pvt
        case UserType.biz.rawValue:
            return .biz
        default:
            break
        }
        return .None
    }

    private func getId () -> Int {
        let dict = self.getUserProfile()
        switch dict.string("tipologia") {
        case UserType.pvt.rawValue:
            return dict.int("pvt_id")
        case UserType.biz.rawValue:
            return dict.int("biz_id")
        default:
            break
        }
        return 0
    }
    
    private func getUserProfile() -> JsonDict {
        let dict = self.userConfig?.dictionaryRepresentation()
        guard dict != nil else {
            return [:]
        }
        return dict!.dictionary(userKey)
    }
    
    func logout() {
        let dict = self.userConfig?.dictionaryRepresentation()
        for key in (dict?.keys)! {
            self.userConfig?.removeObject(forKey: key)
        }
    }
    
    func saveUser(_ dict:JsonDict, name:String, pass:String) {
        var userDict = JsonDict()
        for key in dict.keys {
            let value = dict.string(key)
            if value.isEmpty == false {
                userDict[key] = dict.string(key)
            }
        }
        self.userConfig?.setValue(userDict, forKey: userKey)
    }
}

enum FollowType: String {
    case BIZ
    case PVT
    case DOG
};

class FollowClass {
    class func loadFollowed () {
        FollowClass().loadData()
    }
    class func isIdFollowed (followedId: Int, type: FollowType) -> Bool {
        return FollowClass().isIdFollowed (followedId: followedId, type: type)
    }
    class func followedUpdateId (followedId: Int, type: FollowType, isFollowed: Bool) {
        FollowClass().followedUpdateId (followedId: followedId, type: type, isFollowed: isFollowed)
    }

    var followList = [String: [Int]]()
    
    func loadData() {
        let userId = UserClass().userId
        if userId == 0 {
            return
        }
        let dict = UserClass().userProfile
        let userType = dict.string("tipologia")
        if userType.isEmpty {
            return
        }
        
        let request =  MYHttpRequest.pvt("user-followed-list")
        request.json = [
            "follower_id"   : userId,
            "follower_type" : userType
        ]
        
        request.start(showWheel: false) { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    private func httpResponse(_ resultDict: JsonDict) {
        let array = resultDict.array("followed_list")
        for dict in array as! [JsonDict] {
            let followedType = dict.string("FollowingRelation.followed_type")
            let followedId = dict.int("FollowingRelation.followed_id")

            var followedArray = [Int]()
            if self.followList[followedType] == nil {
                self.followList[followedType] = followedArray
            }
            else {
                followedArray = self.followList[followedType]! as [Int]
            }
            
            if followedArray.contains(followedId) == false {
                followedArray.append(followedId)
                self.followList[followedType] = followedArray
            }
        }
    }
    func isIdFollowed (followedId: Int, type: FollowType) -> Bool {
        let followedArray = self.followList[type.rawValue]! as [Int]
        return followedArray.contains(followedId)
    }
    
    func followedUpdateId (followedId: Int, type: FollowType, isFollowed: Bool) {
        var followedArray = self.followList[type.rawValue]! as [Int]
        if isFollowed {
            if followedArray.contains(followedId) {
                return
            }
            followedArray.append(followedId)
        }
        else {
            if followedArray.contains(followedId) == false {
                return
            }
            let i = followedArray.index(of: followedId)
            followedArray.remove(at: i!)
        }
        self.followList[type.rawValue] = followedArray
    }
}
