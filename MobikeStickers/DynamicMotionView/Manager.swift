//
//  Manager.swift
//  MobikeStickers
//
//  Created by JinK on 2017/7/27.
//  Copyright © 2017年 JinK. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class Manager: NSObject {
    
    static let `default` = Manager()
    
    weak var borderView: UIView!
    
    var playRoundViews: [PlayRoundView]?
    
    lazy var motionManager: CMMotionManager = {
        let motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.05 // 回调时间
        return motionManager
    }()
    
    var animator: UIDynamicAnimator! // 类似容器，在屏幕每次重绘时调整内部每个物体的位置
    
    lazy var gravityBehavior: UIGravityBehavior = { // 重力行为
        let gravityBehavior = UIGravityBehavior()
        return gravityBehavior
    }()
    
    lazy var collisionBehavior: UICollisionBehavior = { // 碰撞行为
        let collisionBehavior = UICollisionBehavior()
        
        /* 
         *  碰撞检测有时候会不准确（会有元素逃出边界，摩拜也有这个情况，目前没找到解决方案）
         */
        
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true // 碰撞边界 1

//        // 碰撞边界 2
//        collisionBehavior.addBoundary(withIdentifier: "BoundaryA" as NSString, for: UIBezierPath(roundedRect: UIEdgeInsetsInsetRect(self.borderView.bounds, UIEdgeInsetsMake(5, 5, -5, -5)), cornerRadius: 0))
//        collisionBehavior.addBoundary(withIdentifier: "BoundaryA" as NSString, for: UIBezierPath(roundedRect: self.borderView.bounds, cornerRadius: 0))
//        collisionBehavior.collisionDelegate = self
        
        collisionBehavior.collisionMode = .everything // 碰撞模式：所有都碰撞
        return collisionBehavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = { // 动态行为控制
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.allowsRotation = true // 是否能旋转
        itemBehavior.density = 0.5 // 物体密度
        itemBehavior.friction = 1 // 摩擦系数
        itemBehavior.elasticity = 0.3 // 弹性系数 0 ~ 1
        return itemBehavior
    }()
    
    func add(playRoundViews: [PlayRoundView], to stickerPlaygroundView: StickerPlaygroundView) {
        
        borderView = stickerPlaygroundView
        
        self.playRoundViews = playRoundViews
        
        animator = UIDynamicAnimator(referenceView: borderView)

        for playRoundView in playRoundViews {
            gravityBehavior.addItem(playRoundView)
            collisionBehavior.addItem(playRoundView)
            itemBehavior.addItem(playRoundView)
        }

        // 添加行为
        addBehavior()
        
        // 添加陀螺仪检测
        addMotion()
    }
    
    func addBehavior() {
        animator.addBehavior(gravityBehavior)
        animator.addBehavior(collisionBehavior)
        animator.addBehavior(itemBehavior)
    }
    
    func addMotion() {
        
        if motionManager.isAccelerometerAvailable { // 陀螺仪是否可用
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (motion, error) in
                if let motion = motion {
                    let gravity = motion.gravity
                    self.gravityBehavior.gravityDirection = CGVector(dx: gravity.x * 5, dy: -gravity.y * 5) // Y 轴要取反
                }
            })
        }
        
    }
    
    func removeMotion() { // 控制器释放时候 删除资源
        if let playRoundViews = playRoundViews{
            for playRoundView in playRoundViews {
                gravityBehavior.removeItem(playRoundView)
                collisionBehavior.removeItem(playRoundView)
                itemBehavior.removeItem(playRoundView)
            }
        }
        playRoundViews = nil
        animator.removeAllBehaviors()
        if motionManager.isDeviceMotionActive { // 停止陀螺仪检测
            motionManager.stopDeviceMotionUpdates()
        }
    
    }
    
    
}

