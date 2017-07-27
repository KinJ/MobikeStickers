//
//  StickerPlaygroundView.swift
//  MobikeStickers
//
//  Created by JinK on 2017/7/27.
//  Copyright © 2017年 JinK. All rights reserved.
//

import UIKit
import CoreMotion

class StickerPlaygroundView: UIView {

    var imgStrs: [String]
    var itemSize: CGSize
    
    deinit {
        print("StickerPlaygroundView -- deinit")
    }
    
    init(frame: CGRect, imgStrs: [String], itemSize: CGSize) {
        self.imgStrs = imgStrs
        self.itemSize = itemSize
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    func setupUI() {
        
        let w = itemSize.width
        let h = itemSize.height
        let lrMargin: CGFloat = 30 // 左右两边间距
        let margin = (frame.width - w * CGFloat(imgStrs.count) - lrMargin) / CGFloat(imgStrs.count - 1) // 两个 PlayRoundView 间距 可能为负 负的时候 PlayRoundView 有重叠部分
        var tmpViews: [PlayRoundView] = []
        for (index, value) in imgStrs.shuffled().enumerated() {
            
            let frame = CGRect(x: (margin + w) * CGFloat(index) + lrMargin * 0.5, y: 10, width: w, height: h)
            
            let playRoundView = PlayRoundView(frame: frame, imgStr: value)
            
            addSubview(playRoundView)
            
            tmpViews.append(playRoundView)
            
        }
        
        // 添加物理仿真及陀螺仪
        Manager.default.add(playRoundViews: tmpViews, to: self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

/// 随机打乱数组 这样每次进来 同一个图片的 Item 位置会变

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
