//
//  SecondViewController.swift
//  SensitiveWordFiltering
//
//  Created by zhixing on 2019/9/14.
//  Copyright © 2019 zhixing. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    private lazy var sensitiveWordFilter: SensitiveWordFilter = {
        return SensitiveWordFilter()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let filterResult = sensitiveWordFilter.filter(text: "")
        print("\(filterResult.isContain)=\(filterResult.filteredText)")
    }

    deinit {
        print("释放")
    }

}
