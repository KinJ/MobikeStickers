//
//  PlayRoundView.swift
//  MobikeStickers
//
//  Created by JinK on 2017/7/27.
//  Copyright © 2017年 JinK. All rights reserved.
//

import UIKit

class PlayRoundView: UIImageView {

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType { // 重写 collisionBoundsType 此属性控制 Item 形状 默认是 View 形状，那样碰撞会是长方形的碰撞
        return .ellipse
    }
    
    init(frame: CGRect, imgStr: String) {
        super.init(frame: frame)
        self.image = UIImage(named: imgStr)
    }
    
    deinit {
        print("PlayRoundView -- deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
