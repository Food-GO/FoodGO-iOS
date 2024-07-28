//
//  NinthTasteTestViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/28/24.
//

import UIKit

class NinthTasteTestViewController: BaseTasteTestViewController {
    
    init() {
        super.init(step: 0.9, questionText: "식당에 갔을 때 어떤 음식을 시도해보고 싶나요?", firstChoice: "식당의 인기 메뉴", secondChoice: "새로운 요리", thirdChoice: "평소에 좋아하는 음식")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func nextButtonTapped() {
        let nextViewController = LastTasteTestViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

