//
//  OnboardingViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit
import SnapKit

class OnboardingContainerViewController: UIViewController {
    
    let pageViewController: UIPageViewController
    var pages = [UIViewController]()
    
    var currentVC: UIViewController {
        didSet {
            
        }
    }
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = .lightGray
        control.pageIndicatorTintColor = .gray
        control.backgroundColor = .white
        control.addTarget(self, action: #selector(pageControlHandler), for: .valueChanged)
        return control
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.textColor = .black
        button.backgroundColor = .red.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        let page1 = FirstOnboardingViewController()
        let page2 = SecondOnboardingViewController()
        
        pages.append(page1)
        pages.append(page2)
        
        currentVC = pages.first ?? UIViewController()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setPageControllerUI()
        setUI()
    }
    
    private func setPageControllerUI() {
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageViewController.view.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-200)
        })
        
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: false, completion:  nil)
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        self.view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints({
            $0.top.equalTo(self.pageViewController.view.snp.bottom)
            $0.centerX.equalToSuperview()
        })
    }
    
    private func setUI() {
        self.view.addSubview(startButton)
        startButton.snp.makeConstraints({
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(90)
        })
    }
    
    @objc private func pageControlHandler(_ sender: UIPageControl) {
        guard let currnetViewController = self.pageViewController.viewControllers?.first,
              let currnetIndex = pages.firstIndex(of: currnetViewController) else { return }
        
        let direction: UIPageViewController.NavigationDirection = (sender.currentPage > currnetIndex) ? .forward : .reverse
        self.pageViewController.setViewControllers([pages[sender.currentPage]], direction: direction, animated: false)
    }
    
    @objc private func nextButtonTapped() {
        UserDefaultsManager.shared.isFirstLaunched = false
        
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true)
    }
    
}

// MARK: - PageViewController Ext
extension OnboardingContainerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getPreviousViewController(from: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getNextViewController(from: viewController)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: self.currentVC) ?? 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        
        guard let viewControllers = pageViewController.viewControllers,
              let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
    }
    
    private func getPreviousViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        currentVC = pages[index - 1]
        return pages[index - 1]
    }
    
    private func getNextViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index + 1 < pages.count else { return nil }
        currentVC = pages[index + 1]
        return pages[index + 1]
    }
    
}
