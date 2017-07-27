//
//  ViewController.swift
//  MobikeStickers
//
//  Created by JinK on 2017/7/27.
//  Copyright © 2017年 JinK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var imgStrs: [String] = []
        
        for value in 1..<12 {
            imgStrs.append("\(value)")
        }
        
        
        let v = StickerPlaygroundView(frame: CGRect(x: 0, y: view.frame.height * 0.3, width: view.frame.width, height: view.frame.height * 0.4), imgStrs: imgStrs, itemSize: CGSize(width: 50, height: 50))
        v.backgroundColor = .brown
        view.addSubview(v)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit { // 释放资源
//        print("ViewController -- deinit")
        Manager.default.removeMotion()
    }

}

