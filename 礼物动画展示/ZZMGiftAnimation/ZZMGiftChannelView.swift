//
//  ZZMGiftChannelView.swift
//  礼物动画展示
//
//  Created by zhang on 2017/7/13.
//  Copyright © 2017年 zhangzhiming. All rights reserved.
//

import UIKit


enum HYGiftChannelState {
    case idle
    case animating
    case willEnd
    case endAnimating
}


class ZZMGiftChannelView: UIView {

    // MARK: 控件属性
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var giftDescLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var digitLabel: ZZMGiftDigitLabel!
    
    fileprivate var cacheNumber : Int = 0        /// 缓存个数
    fileprivate var currentNumber : Int = 0
    var state : HYGiftChannelState = .idle
    var completionBlockCallback : ((ZZMGiftChannelView) -> Void)?  /// 动画完成的回调
    
    var giftModel : ZZMGiftModel? {
        didSet {
            // 1.对模型进行校验
            guard let giftModel = giftModel else {
                return
            }
            
            // 2.给控件设置信息
            iconImageView.image = UIImage(named: giftModel.senderURL)
            senderLabel.text = giftModel.senderName
            giftDescLabel.text = "送出礼物： \(giftModel.giftName) "
            giftImageView.image = UIImage(named: giftModel.giftURL)
            
            // 3.将ChanelView弹出
            state = .animating
            performAnimation()
        }
    }
}


// MARK:- 设置UI界面
extension ZZMGiftChannelView { 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.layer.cornerRadius = frame.height * 0.5
        iconImageView.layer.cornerRadius = frame.height * 0.5
        bgView.layer.masksToBounds = true
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.green.cgColor
    }
}


// MARK: - mark - 对外提供的函数
extension ZZMGiftChannelView {

    func addOnceToCache() {
        
        if state == .willEnd {
            performDigitAnimation()
            NSObject.cancelPreviousPerformRequests(withTarget: self)    /// 取消延迟执行的方法
        }else {
            cacheNumber += 1
        }
    }
    
    class func loadFromNib() -> ZZMGiftChannelView {
        return Bundle.main.loadNibNamed("ZZMGiftChannelView", owner: nil, options: nil)?.first as! ZZMGiftChannelView
    }
}


// MARK:- 执行动画代码
extension ZZMGiftChannelView {
    fileprivate func performAnimation() {
        digitLabel.alpha = 1.0
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.frame.origin.x = 0
        }, completion: { isFinished in
            self.performDigitAnimation()
        })
    }
    
    fileprivate func performDigitAnimation() {
        currentNumber += 1
        digitLabel.text = "x \(currentNumber)"
        digitLabel.showDigitAnimation {
            
            if self.cacheNumber > 0 {
                self.state = .animating
                self.cacheNumber -= 1
                self.performDigitAnimation()
            } else {
                self.state = .willEnd
                self.perform(#selector(self.performEndAnimation), with: nil, afterDelay: 2.0)
            }
        }
    }
    
    @objc fileprivate func performEndAnimation() {
        
        state = .endAnimating
        
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.x = UIScreen.main.bounds.width
            self.alpha = 0.0
        }, completion: { isFinished in
            
            self.cacheNumber = 0
            self.currentNumber = 0
            self.giftModel = nil   /// 不清空会出问题的
            self.frame.origin.x = -self.frame.width
            self.state = .idle
            self.digitLabel.alpha = 0.0
            self.digitLabel.text = ""
            if let completionBlockCallback = self.completionBlockCallback {
                completionBlockCallback(self)
            }
        })
    }
}













