//
//  MapViewControllerMapKit.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 23.11.2022.
//

import UIKit
import MapKit
import CoreLocation

final class MapViewControllerMapKit: UIViewController {

    private let presenter: MapPresenter

    private var mapView: MKMapView

    //MARK: - Life Cycle

    init(presenter: MapPresenter, mapView: MKMapView) {
        self.presenter = presenter
        self.mapView = mapView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        openMap()

    }

    //MARK: - Layout

    private func setupSubviews() {
        view.addSubview(mapView)

        configureConstraints()
    }

    private func configureConstraints() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: - Helpers

    func openMap() {

        let shops = presenter.getShops()
        for shop in shops {
            let mapObjects = mapView
        }

    }

    private func didTapShop(_ shop: Shop) {
        let childViewController = MapChildViewController(presenter: presenter)
        add(childViewController, frame: CGRect(
            x: view.center.x - 200,
            y: view.center.y - 50,
            width: 400,
            height: 100
        ))
        presenter.childViewController = childViewController
        presenter.updateViews()
    }

}

@nonobjc extension MapViewControllerMapKit {

    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)

        if let frame = frame {
            child.view.frame = frame
        }

        view.addSubview(child.view)
    }

    func remove() {
        presenter.childViewController?.view.removeFromSuperview()
        presenter.childViewController?.removeFromParent()
        presenter.childViewController = nil
    }

}

