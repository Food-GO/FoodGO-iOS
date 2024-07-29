//
//  SixthTasteTestViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/28/24.
//

import UIKit

class SixthTasteTestViewController: BaseTasteTestViewController {
    
    init() {
        super.init(step: 0.6, questionText: "아침 식사로 어떤 음식을 선호하나요?", firstChoice: "신선한 스무디", secondChoice: "든든한 오트밀", thirdChoice: "아침은 건너뛰어요.")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func nextButtonTapped() {
        let nextViewController = SeventhTasteTestViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

