//
//  ViewController.swift
//  GCSwiftLabelView
//
//  Created by 506227061@qq.com on 07/29/2020.
//  Copyright (c) 2020 506227061@qq.com. All rights reserved.
//

import UIKit
import GCSwiftLabelView

class ViewController: UIViewController {
    
    let labelView: GCLabelView = GCLabelView.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var dataList: Array<GCLabelModel> = []
        for i in 0..<10 {
            let model: GCLabelModel = GCLabelModel.init(name: "我的\(i)", image: nil)
            dataList.append(model)
        }
        labelView.backgroundColor = UIColor.green
        labelView.layoutForDataArray(array: dataList)
        self.view.addSubview(labelView)
        labelView.labelItemSelected = { newSelItem, oldSelItem in
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("\(#function): ViewController")
        labelView.frame = CGRect.init(x: 0, y: 100, width: self.view.frame.width, height: 200)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

