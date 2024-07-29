//
//  FourthTasteTestViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/28/24.
//

import UIKit

class FourthTasteTestViewController: BaseTasteTestViewController {
    
    init() {
        super.init(step: 0.4, questionText: "매운 음식을 얼마나 좋아하나요?", firstChoice: "매우 매운 음식도 좋아해요.", secondChoice: "적당히 매운 게 좋아요.", thirdChoice: "매운 음식은 별로예요.")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func nextButtonTapped() {
        let nextViewController = FifthTasteTestViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

