//
//  EmptyFoodRecordView.swift
//  YoriJori
//
//  Created by 김강현 on 9/22/24.
//

import UIKit
import SnapKit

class EmptyFoodRecordView: UIView {
    
    private let recordLabel = UILabel().then {
        $0.text = "기록"
        $0.font = DesignSystemFont.bold16
        $0.textColor = DesignSystemColor.gray900
    }
    
    private let recordDescLabel = UILabel().then {
        $0.text = "오늘 먹은 음식은 어땠나요?\n식단을 기록해 보세요"
        $0.font = DesignSystemFont.semibold14
        $0.textColor = DesignSystemColor.gray600
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let recordButton = YorijoriButton(bgColor: DesignSystemColor.white, textColor: DesignSystemColor.gray800
                                              , borderColor: DesignSystemColor.gray150, selectedBorderColor: DesignSystemColor.gray150).then {
        $0.text = "식단 기록하기"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = DesignSystemColor.white
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [recordLabel, recordDescLabel, recordButton].forEach({self.addSubview($0)})
        
        recordLabel.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        })
        
        recordDescLabel.snp.makeConstraints({
            $0.top.equalTo(self.recordLabel.snp.bottom).offset(42)
            $0.centerX.equalToSuperview()
        })
        
        recordButton.snp.makeConstraints({
            $0.top.equalTo(self.recordDescLabel.snp.bottom).offset(42)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(42)
        })
        
    }
    
}
