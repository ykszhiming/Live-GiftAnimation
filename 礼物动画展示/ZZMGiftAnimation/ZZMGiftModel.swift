//
//  HYGiftModel.swift
//  GiftAnim
//
//  Created by apple on 16/11/20.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit

class ZZMGiftModel: NSObject {
    var senderName : String = ""    /// 昵称
    var senderURL : String = ""     /// 头像
    var giftName : String = ""      /// 礼物名称
    var giftURL : String = ""       /// 礼物图片 
    
    init(senderName : String, senderURL : String, giftName : String, giftURL : String) {
        self.senderName = senderName
        self.senderURL = senderURL
        self.giftName = giftName
        self.giftURL = giftURL
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? ZZMGiftModel else {
            return false
        }
        
        guard object.giftName == giftName && object.senderName == senderName else {
            return false
        }
        
        return true
    }
}
