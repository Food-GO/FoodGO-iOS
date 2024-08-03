//
//  ManualAddFoodViewModel.swift
//  YoriJori
//
//  Created by 김강현 on 8/3/24.
//

import RxSwift
import RxCocoa
import UIKit

class ManualAddFoodViewModel {
    // Inputs
    let foodName = BehaviorRelay<String>(value: "")
    let photoImage = BehaviorRelay<UIImage?>(value: nil)
    
    // Outputs
    let isNextButtonEnabled: Observable<Bool>
    
    init() {
        isNextButtonEnabled = Observable.combineLatest(foodName, photoImage)
            .map { foodName, photoImage in
                return !foodName.isEmpty && photoImage != nil
            }
    }
    
    func setPhoto(_ image: UIImage?) {
        photoImage.accept(image)
    }
}
