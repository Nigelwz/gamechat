//
//  User.swift
//  gamechat
//
//  Created by eric on 2019/1/24.
//  Copyright © 2019 eric. All rights reserved.
//

import UIKit

class User: NSObject {
    //swift 宣告 要交 @objc 不然setvalue(dictionary)會 carash
    @objc var id:String?
    @objc var email: String?
    @objc var name: String?
    @objc var profileImageUrl: String?
}
