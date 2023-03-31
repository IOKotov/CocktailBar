//
//  OnboardingNetworkService.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 20.09.2022.
//

import Foundation

protocol OnboardingNetworkServiceInterface {
    func getOnboardingItems(completion: @escaping (OnboardingItems?) -> Void)
//    func getOnboardingImage(items: String, completion: @escaping (OnboardingImage?) -> Void)
}

final class OnboardingNetworkService: OnboardingNetworkServiceInterface {

    func getOnboardingItems(completion: @escaping (OnboardingItems?) -> Void) {
        let plugin: OnboardingApiIDB = .getOnboarding
        NetworkRequest<OnboardingItems>.request(plugin: plugin) { response in
            completion(response)
        }
    }

//    func getOnboardingImage(items: String,
//                           completion: @escaping (OnboardingImage?) -> Void) {
//        let plugin: OnboardingAPI = .getOnboarding(items)
//        NetworkRequest<OnboardingImage>.request(plugin: plugin) { response in
//            completion(response)
//        }
//    }
    
}
