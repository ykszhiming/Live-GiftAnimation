# Live-GiftAnimation

### 1. 容器view
* 创建两条轨道view 放入轨道数组 `channelViews`
* 创建礼物模型缓存数组 `cacheGiftModels`
* 容器view入口 `showGiftModel`

```objc
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
```
* 轨道view的回调函数 `showGiftModel`

```objc
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
            }               
```


### 2. 轨道view
* 获取模型数据 `giftModel` 并设置UI信息
* 枚举动画状态 `(0)idle` `(1)animating` `(2)willEnd` `(3)endAnimating` 
* 开始弹出动画 `performAnimation` `state = .animating`
* 对外提供累加函数 `addOnceToCache`

```objc
    func addOnceToCache() {
        
        if state == .willEnd {
            performDigitAnimation()
            NSObject.cancelPreviousPerformRequests(withTarget: self)    /// 取消延迟执行的方法
        }else {
            cacheNumber += 1
        }
    }
```
* 开始连击动画 `currentNumber`为 0 时 延迟结束动画，两秒内可以再次连击

```objc
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
```
* 结束动画 执行回调函数



### 3. 动画label
* 	描边 `drawText`
* 	展示数字动画 `showDigitAnimation`





