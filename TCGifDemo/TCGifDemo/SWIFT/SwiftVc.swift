//
//  SwiftVc.swift
//  TCGifDemo
//
//  Created by Tech on 2017/6/6.
//  Copyright © 2017年 ctc. All rights reserved.
//

import UIKit

class SwiftVc: UIViewController {

    @IBOutlet weak var iv: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iv.tc_setGif(withName: "pikaqiu")
    } 



}
