//
//  LastTasteTestViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/28/24.
//

import UIKit

class LastTasteTestViewController: BaseTasteTestViewController {
    
    init() {
        super.init(step: 1.0, questionText: "현재 식단 목표는 무엇인가요?", firstChoice: "체중 감량", secondChoice: "근육 증가", thirdChoice: "균형 잡힌 식단 유지")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func nextButtonTapped() {
        let nextViewController = TasteTestResultViewController(bgColor: UIColor(hex: "#FFA06B"), characterImage: UIImage(named: "red_character")!, typeTextColor: UIColor(hex: "#B92100"), type: "에너지 운동가", typeDesc: "활력있는 취향인")
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

