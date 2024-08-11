//
//  LoadingIndicator.swift
//  YoriJori
//
//  Created by 김강현 on 8/11/24.
//

import UIKit

class LoadingIndicator {
    static func showLoading() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
            
            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 반투명 배경 추가
                loadingIndicatorView.color = DesignSystemColor.yorijoriPink
                window.addSubview(loadingIndicatorView)
            }
            
            loadingIndicatorView.startAnimating()
        }
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
