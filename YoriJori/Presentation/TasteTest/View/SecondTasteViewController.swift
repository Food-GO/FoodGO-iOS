//
//  SecondTasteViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/28/24.
//

import UIKit

class SecondTasteTestViewController: BaseTasteTestViewController {
    
    init() {
        super.init(step: 0.2, questionText: "새로운 요리를 시도해볼 생각이 있나요?", firstChoice: "새로운 맛은 언제나 환영!", secondChoice: "가끔은 좋아요.", thirdChoice: "익숙한 맛이 좋아요.")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func nextButtonTapped() {
        let nextViewController = ThirdTasteTestViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
