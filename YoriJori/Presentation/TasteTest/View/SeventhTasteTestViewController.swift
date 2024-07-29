//
//  SeventhTasteTestViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/28/24.
//

import UIKit

class SeventhTasteTestViewController: BaseTasteTestViewController {
    
    init() {
        super.init(step: 0.7, questionText: "음식을 선택할 때 가장 중요한 요소는 무엇인가요?", firstChoice: "건강", secondChoice: "맛", thirdChoice: "편리함")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func nextButtonTapped() {
        let nextViewController = EighthTasteTestViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

