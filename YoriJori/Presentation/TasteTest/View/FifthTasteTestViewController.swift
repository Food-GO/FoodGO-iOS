//
//  FifthTasteTestViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/28/24.
//

import UIKit

class FifthTasteTestViewController: BaseTasteTestViewController {
    
    init() {
        super.init(step: 0.5, questionText: "간식으로 무엇을 먹고 싶나요?", firstChoice: "과일과 견과류", secondChoice: "단백질 쉐이크", thirdChoice: "과자와 초콜릿")
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func nextButtonTapped() {
        let nextViewController = SixthTasteTestViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

