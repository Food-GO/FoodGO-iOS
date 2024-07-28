//
//  ThirdTasteTestViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/28/24.
//

import UIKit

class ThirdTasteTestViewController: BaseTasteTestViewController {
    
    init() {
        super.init(step: 0.3, questionText: "외식할 때 선호하는 음식은 무엇인가요?", firstChoice: "다양한 뷔페", secondChoice: "고급 레스토랑", thirdChoice: "편안한 패스트푸드")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func nextButtonTapped() {
        let nextViewController = FourthTasteTestViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
