//
//  OnboardingPageViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 20.09.2022.
//

import UIKit
import SnapKit

final class OnboardingPageViewController: UIPageViewController {

    private let presenter: OnboardingPresenter

    //MARK: - UI Elements

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .black
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        return pageControl
    }()

    //MARK: - Life Cycle

    init(presenter: OnboardingPresenter) {
        self.presenter = presenter

        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.loadData()
        setupSubviews()
    }

    //MARK: - Layout

    private func setupSubviews() {
        view.addSubview(pageControl)
        configureConstraints()
    }

    private func configureConstraints() {
        pageControl.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }

    //MARK: - Actions

    @objc private func pageControlChanged(_ sender: UIPageControl) {
        let page: Int? = sender.currentPage
        setViewControllers([presenter.onboardingViewControllers[page ?? 0]], direction: .forward, animated: true, completion: nil)
    }

    //MARK: - Helpers

    func populateView(onboardingViewControllers: [OnboardingViewController]) {
        guard let firstViewController = onboardingViewControllers.first else { return }
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            dataSource = self
    }

}

//MARK: - UIPageViewControllerDataSource

extension OnboardingPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentOnboardingViewController = viewController as? OnboardingViewController else { return nil }
        guard let currentIndex = presenter.onboardingViewControllers.firstIndex(
            of: currentOnboardingViewController
        ) else { return nil }
        pageControl.currentPage += 1
        guard currentIndex + 1 != presenter.onboardingViewControllers.count else { return nil }
        let nextViewController = presenter.onboardingViewControllers[currentIndex + 1]
        if currentIndex + 2 == presenter.onboardingViewControllers.count {
            nextViewController.setButtons()
        }
        return nextViewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentOnboardingViewController = viewController as? OnboardingViewController else { return nil }
        guard let currentIndex = presenter.onboardingViewControllers.firstIndex(of: currentOnboardingViewController) else { return nil }
        pageControl.currentPage -= 1
        guard currentIndex != 0 else { return nil }
        return presenter.onboardingViewControllers[currentIndex - 1]
    }

}
