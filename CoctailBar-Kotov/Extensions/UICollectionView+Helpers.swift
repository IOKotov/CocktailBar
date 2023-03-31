//
//  UICollectionView+Helpers.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 26.07.2022.
//

import UIKit

// MARK: - UICollectionViewCell

extension UICollectionView {
    
    func register<C: UICollectionViewCell>(cellType: C.Type) where C: ClassIdentifiable {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseId)
    }
    
    func dequeueReusableCell<C: UICollectionViewCell>(withCellType type: C.Type = C.self, for indexPath: IndexPath) -> C where C: ClassIdentifiable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.reuseId, for: indexPath) as? C
        else { fatalError(makeItemError(withIdentifier: type.reuseId, type: C.self)) }
        return cell
    }
    
}

// MARK: - UICollectionReusableView

extension UICollectionView {
    
    enum SupplementaryViewKind {
        case header
        case footer
        
        var identifier: String {
            switch self {
            case .header:
                return elementKindSectionHeader
            case .footer:
                return elementKindSectionFooter
            }
        }
    }
    
    func registerView<C: UICollectionReusableView>(ofKind kind: SupplementaryViewKind, viewType: C.Type) where C: ClassIdentifiable {
        register(viewType.self, forSupplementaryViewOfKind: kind.identifier, withReuseIdentifier: viewType.reuseId)
    }
    
    func dequeueReusableView<C: UICollectionReusableView>(ofKind kind: SupplementaryViewKind, withViewType type: C.Type = C.self, for indexPath: IndexPath) -> C where C: ClassIdentifiable {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind.identifier, withReuseIdentifier: type.reuseId, for: indexPath) as? C
        else { fatalError(makeItemError(withIdentifier: type.reuseId, type: C.self)) }
        return view
    }
    
}

// MARK: - Dequeue Error Method

extension UICollectionView {
    
    private func makeItemError<T>(withIdentifier reuseIdentifier: String, type _: T) -> String {
        return "Couldn’t dequeue \(T.self) with identifier \(reuseIdentifier)"
    }

}
