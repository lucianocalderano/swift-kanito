//
//  MYHttp.swift
//  Enci
//
//  Created by Luciano Calderano on 07/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

typealias JsonDict = Dictionary<String, Any>

struct WheelConfig {
    static var backWheelImage:UIImage?
}

extension MYHttpRequest {
    struct HttpConfig {
        static let pvt = [
            "http://www.kanito.it/mobile/",
            "A221F6>S)>Z#1i`Md6D6Efl?:$9J)9CKy[ol396+U10MBTrj2;0juwCR~6b-igi"
        ]
        static let biz = [
            "http://software.kanito.it/mobile/api/",
            "B221F6>S)>Z#1i`Md6D6Efl?:$(iUsad73%90Aa£$)+U10MBTrj2;0juwCR~6b-igi"
        ]
    }
    static let printJson = false
    
    class func pvt (_ page: String) -> MYHttpRequest {
        let config = HttpConfig.pvt
        return MYHttpRequest (auth: config[1], page: config[0] + page)
    }
    
    class func biz (_ page: String) -> MYHttpRequest {
        let config = HttpConfig.biz
        return MYHttpRequest (auth: config[1], page: config[0] + page)
    }
}

/** Kanito **/

enum LangType: String {
    case code
    case id
    case iso
}

func getLangCodeForType (_ type: LangType) -> String {
    let dict = UserDefaults.standard.object(forKey: "Language") as! JsonDict
    return dict.string(type.rawValue)
}

enum ItemMenu {
    case Home
    case MyKanito
    case DogBuddy
    case Login
    case Reg
    case Logout
    case Dash
    case Cust
    case Dog
    case Less
    case Adozioni
    case Explore
    case Upload
    case PetServices
    case NeedToLogin
}

