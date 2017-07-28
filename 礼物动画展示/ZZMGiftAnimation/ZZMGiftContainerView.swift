//
//  ZZMGiftContainerView.swift
//  礼物动画展示
//
//  Created by zhang on 2017/7/13.
//  Copyright © 2017年 zhangzhiming. All rights reserved.
//

import UIKit

private let kChannelCount = 2
private let kChannelViewH : CGFloat = 40
private let kChannelMargin : CGFloat = 10

class ZZMGiftContainerView: UIView {

    
    // MARK: - mark - 定义属性
    fileprivate lazy var channelViews : [ZZMGiftChannelView] = [ZZMGiftChannelView]()
    fileprivate lazy var cacheGiftModels : [ZZMGiftModel] = [ZZMGiftModel]()
    
    // MARK: - mark - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 设置UI界面
extension ZZMGiftContainerView {
    fileprivate func setupUI() {
        // 1.根据当前的渠道数，创建HYGiftChannelView
        let w : CGFloat = frame.width
        let h : CGFloat = kChannelViewH
        let x : CGFloat = 0
        for i in 0..<kChannelCount {
            let y : CGFloat = (h + kChannelMargin) * CGFloat(i)
            
            let channelView = ZZMGiftChannelView.loadFromNib()
            channelView.frame = CGRect(x: x, y: y, width: w, height: h)
            channelView.alpha = 0.0
            addSubview(channelView)
            channelViews.append(channelView)
            
            channelView.completionBlockCallback = { tempChannelView in
                /// 1. 取出缓存中的模型
                guard self.cacheGiftModels.count != 0 else {
                    return
                }
                /// 2.取出缓存中的第一个模型
                let firstGiftModel = self.cacheGiftModels.first!
                self.cacheGiftModels.removeFirst()
                
                /// 3.更新 model
                tempChannelView.giftModel = firstGiftModel
                
                
                
                for i in (0..<self.cacheGiftModels.count).reversed() {
                    let giftModel = self.cacheGiftModels[i]
                    if giftModel.isEqual(firstGiftModel) {
                        tempChannelView.addOnceToCache()
                        self.cacheGiftModels.remove(at: i)
                    }
                }
//                self.cacheGiftModels = self.cacheGiftModels.filter({!$0.isEqual(firstGiftModel)}) /// 用过滤也可以
                
            }
        }
    }
}


extension ZZMGiftContainerView {

    
    func showGiftModel(_ giftModel: ZZMGiftModel) {
        
        /// 1. 判断正在忙的 chanelView和赠送的新礼物(username / giftname) 判断连击
        if let channelView = checkUsingChanelView(giftModel) {
            channelView.addOnceToCache() /// 执行连击
            return
        }
        
        /// 2. 判断有没有闲置的 chanelView
        if let channelView = checkIdleChanelView() {
            channelView.giftModel = giftModel  /// 重新赋值 model 触发 didset 刷新页面
            return
        }
        
        /// 3. 将数据放入缓存中
        cacheGiftModels.append(giftModel)
    }
    
    
    /// 检查是否为连击
    private func checkUsingChanelView(_ giftModel : ZZMGiftModel) -> ZZMGiftChannelView? {
        
        for channelView in channelViews {
            if giftModel.isEqual(channelView.giftModel) && channelView.state != .endAnimating {
                return channelView
            }
        }
        return nil
    }
    
    /// 检查是否为闲置
    private func checkIdleChanelView() -> ZZMGiftChannelView? {
        
        for channelView in channelViews {
            if channelView.state == .idle {
                return channelView
            }
        }
        return nil
    }
    
    
    
    
}









