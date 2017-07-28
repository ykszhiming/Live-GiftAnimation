//
//  ViewController.swift
//  礼物动画展示
//
//  Created by zhang on 2017/7/13.
//  Copyright © 2017年 zhangzhiming. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testLabel: ZZMGiftDigitLabel!

    fileprivate var giftContainerView : ZZMGiftContainerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        giftContainerView = ZZMGiftContainerView()
        giftContainerView.frame = CGRect(x: 0, y: 280, width: 240, height: 90)
        giftContainerView.backgroundColor = UIColor.lightGray
        view.addSubview(giftContainerView)
    }

   
    @IBAction func gift1(_ sender: Any) {
        
        let gift1 = ZZMGiftModel(senderName: "heheheh", senderURL: "icon1", giftName: "火箭", giftURL: "prop_g")
        giftContainerView.showGiftModel(gift1)
        
    }
    @IBAction func gift2(_ sender: Any) {
        
        let gift2 = ZZMGiftModel(senderName: "heheheh", senderURL: "icon2", giftName: "飞机", giftURL: "prop_g")
        giftContainerView.showGiftModel(gift2)
    }

    @IBAction func gift3(_ sender: Any) {
        
        let gift3 = ZZMGiftModel(senderName: "heheheh", senderURL: "icon3", giftName: "跑车", giftURL: "prop_g")
        giftContainerView.showGiftModel(gift3)
    }
}

