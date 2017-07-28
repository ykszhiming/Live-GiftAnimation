//
//  ZZMGiftDigitLabel.swift
//  礼物动画展示
//
//  Created by zhang on 2017/7/13.
//  Copyright © 2017年 zhangzhiming. All rights reserved.
//

import UIKit

class ZZMGiftDigitLabel: UILabel {

    
    override func drawText(in rect: CGRect) {
        /// 1.获取上下文
        let context = UIGraphicsGetCurrentContext()
        
        /// 2.给上下文线段设置一个宽带，通过该宽度画出文本
        context?.setLineWidth(3)
        context?.setLineJoin(.round)  /// 会有圆角
        context?.setTextDrawingMode(.stroke)
        textColor = UIColor.orange
        super.drawText(in: rect)
        
        context?.setTextDrawingMode(.fill)
        textColor = UIColor.white
        super.drawText(in: rect)
    }
    
    
    /// @escaping 被闭包调用的闭包必须加入此关键字
    func showDigitAnimation(_ complection : @escaping () -> ()) {
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
        }, completion: { isFinished in
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [], animations: {
                self.transform = CGAffineTransform.identity
            }, completion: { (isFinished) in
                complection()
            })
        })
        
    }
}








