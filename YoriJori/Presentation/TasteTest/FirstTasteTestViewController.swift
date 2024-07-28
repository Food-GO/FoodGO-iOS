//
//  FirstTasteTestViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/28/24.
//

import UIKit

class FirstTasteTestViewController: BaseTasteTestViewController {
    
    init() {
        super.init(step: 0.1, questionText: "오늘 하루 피곤해요.\n어떤 음식을 먹고 싶나요?", firstChoice: "상큼한 과일 샐러드", secondChoice: "든든한 스테이크", thirdChoice: "간단한 샌드위치")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func nextButtonTapped() {
        let nextViewController = SecondTasteTestViewController() 
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
