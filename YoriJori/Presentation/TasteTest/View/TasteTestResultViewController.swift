//
//  TasteTestResultViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/29/24.
//

import UIKit
import SnapKit

class TasteTestResultViewController: UIViewController {
    
    private let resultLabel = UILabel().then {
        $0.text = "이OO님의 취향은,\n건강한 미식가:\n건강하고 균형 잡힌 취향"
        $0.font = DesignSystemFont.title1
        $0.textColor = DesignSystemColor.gray900
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let resultDescLabel = UILabel().then {
        $0.text = "건강을 중요시하며\n신선한 재료와 영양가 높은 음식을 선호합니다.\n추천 음식: 그린 스무디, 그릭 요거트, 퀴노아 샐러드"
        $0.font = DesignSystemFont.title1
        $0.textColor = DesignSystemColor.gray900
        $0.numberOfLines = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = DesignSystemColor.white
        
        setUI()
    }
    
    private func setUI() {
        [resultLabel, resultDescLabel].forEach({self.view.addSubview($0)})
        
        resultLabel.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(166)
            $0.leading.trailing.equalToSuperview().inset(115)
        })
        
        resultDescLabel.snp.makeConstraints({
            $0.top.equalTo(self.resultLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(45)
        })
    }

}
