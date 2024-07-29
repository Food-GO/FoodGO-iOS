//
//  EighthTasteTestViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/28/24.
//

import UIKit

class EighthTasteTestViewController: BaseTasteTestViewController {
    
    init() {
        super.init(step: 0.8, questionText: "저녁 식사로 무엇을 먹고 싶나요?", firstChoice: "가벼운 샐러드", secondChoice: "고기 요리", thirdChoice: "파스타나 피자")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func nextButtonTapped() {
        let nextViewController = NinthTasteTestViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

