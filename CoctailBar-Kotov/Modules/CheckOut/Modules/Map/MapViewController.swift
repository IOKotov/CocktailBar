//
//  MapViewController.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 25.10.2022.
//

import UIKit
import SnapKit
import YandexMapsMobile
//import MapKit

final class MapViewController: UIViewController {

    private let presenter: MapPresenter

//    private var mapView: MKMapView

    private lazy var mapView = YMKMapView(frame: .zero, vulkanPreferred: true)
    private lazy var map: YMKMap = {
        return (mapView?.mapWindow.map)!
    }()
    private lazy var searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
    private var searchSession: YMKSearchSession?

    //MARK: - Life Cycle

    init(presenter: MapPresenter) {
        self.presenter = presenter
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

        guard let mapView = mapView else { return }
        view.addSubview(mapView)

        configureConstraints()
    }

    private func configureConstraints() {
        mapView?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: - Helpers

    func openMap() {

        guard let mapView = mapView else { return }

        let mapObjectCollection = mapView.mapWindow.map.mapObjects

        let shops = presenter.getShops()
        for shop in shops {
            let mapObject = mapObjectCollection.addPlacemark(with: shop.point, image: UIImage(named: "emptyCartTabIcon") ?? UIImage())
            mapObject.userData = shop
        }

        mapObjectCollection.addTapListener(with: self)
        map.addInputListener(with: self)

        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: shops.first?.point ?? YMKPoint(latitude: 54.986289, longitude: 73.363163),
                zoom: 15,
                azimuth: 0,
                tilt: 0
            ),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 2),
            cameraCallback: nil)
    }

    private func didTapShop(_ shop: Shop) {
        mapView?.mapWindow.map.move(
            with: YMKCameraPosition(
                target: shop.point,
                zoom: 15,
                azimuth: 0,
                tilt: 0
            ),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 2),
            cameraCallback: nil)

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

//MARK: YMKMapObjectTapListener

extension MapViewController: YMKMapObjectTapListener, YMKMapInputListener {

    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let shop = mapObject.userData as? Shop else { return false }
        didTapShop(shop)

//        let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error?) -> Void in
//            if let response = searchResponse {
//                self.onSearchResponse(response)
//            }
//        }

//        searchSession = searchManager.submit(with: point, zoom: 15, searchOptions: YMKSearchOptions(), responseHandler: responseHandler)

        return true
    }

//    func onSearchResponse(_ response: YMKSearchResponse) {
//
//        for searchResult in response.collection.children {
//            guard let obj = searchResult.obj else { continue }
//            guard let objMetadata = obj.metadataContainer.getItemOf(YMKSearchToponymObjectMetadata.self) as? YMKSearchToponymObjectMetadata else { continue }
//
//            let address = objMetadata.address
//
//            let formattedAddress = address.formattedAddress
//            let postalCode = address.postalCode ?? "none"
//            let additionalInfo = address.additionalInfo ?? "none"
//
//            print("formattedAddress", formattedAddress)
//            print("postalCode", postalCode)
//            print("additionalInfo", additionalInfo)
//
//            print("components:")
//
//            address.components.forEach {
//                let value = $0.name
//
//                $0.kinds.forEach {
//                    let kind = YMKSearchComponentKind(rawValue: UInt(truncating: $0))
//
//                    switch kind {
//                    case .country:
//                        print("country: \(value)")
//                    case .region:
//                        print("region: \(value)")
//                    case .locality:
//                        print("locality: \(value)")
//                    case .street:
//                        print("street: \(value)")
//                    case .house:
//                        print("house number: \(value)")
//                    default:
//                        break
//                    }
//                }
//            }
//        }
//    }

    func onMapTap(with map: YMKMap, point: YMKPoint) {
        remove()
    }

    func onMapLongTap(with map: YMKMap, point: YMKPoint) {}

}

@nonobjc extension MapViewController {

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
