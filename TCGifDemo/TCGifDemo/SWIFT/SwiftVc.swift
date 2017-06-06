//
//  SwiftVc.swift
//  TCGifDemo
//
//  Created by Tech on 2017/6/6.
//  Copyright © 2017年 ctc. All rights reserved.
//

import UIKit

class SwiftVc: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var newIv: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        iv.tc_setGif(withName: "pikaqiu")
        iv.tc_setGif(with: URL(string: "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2543917993,526494728&fm=23&gp=0.jpg")!)
        

        
    } 

    @IBAction func make(_ sender: UIButton) {
        TCGif.shared().gif(withImages: iv.animationImages, spf: iv.tc_SPF, forKey: "new", completion: { filePath in
            self.newIv.tc_setGif(withFilePath: filePath)
        })

    }
    
    @IBAction func clear(_ sender: UIButton) {
        TCGif.shared().clearCache {
            print("clear successful")
        }
    }
    @IBAction func calculate(_ sender: UIButton) {
        TCGif.shared().calculateCacheSize { (count, size) in
            (self.view.viewWithTag(10086) as! UILabel).text = String(format: "%.1f MB", (CGFloat(size)/1024.0/1024.0))
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        iv.tc_setGif(with: URL(string: textField.text!)!)
        return true
    }
    
}
