//
//  OnboardingItems.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 20.09.2022.
//

import UIKit

struct OnboardingItems: Decodable {

    let items: [Item]
    
}

struct Item: Decodable {

    private enum CodingKeys: String, CodingKey {
        case id
        case imageVersions = "image_versions"
    }

    let id: Int
    let imageVersions: [OnboardingImage]

    var finalImage: OnboardingImage? {
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        for image in imageVersions {
            guard image.height >= Int(screenHeight) else { continue }
            return image
        }
        return nil
    }

    // Есть массив изображений разного размера. Из них нужно выбрать одно, подходящее под высоту экрана. Сделать переменную, и в цикле пройтись и сравнивать высоту онбординг картинки с высотой экрана, как только высота будет >= высоте экрана, то это изображение нам подходит -> ретерним.

}
