//
//  CategoryDrinks.swift
//  CoctailBar-Kotov
//
//  Created by Dmitry Surkov on 23.06.2022.
//

import Foundation

struct CategoryDrinks: Decodable {
 
    let drinks: [Drink]

}

struct Drink: Hashable, Decodable {

    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case imageURL = "strDrinkThumb"
        case instruction = "strInstructions"
        case ingredient = "strIngredient"
        case measure = "strMeasure"
    }

    struct DynamicCodingKeys: CodingKey {

        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            return nil
        }

    }

    let id: String
    let name: String
    let category: String?
    let imageURL: String
    let instruction: String?
    var ingredients: [Ingredient] = []

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try? container.decode(String.self, forKey: .category)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        instruction = try? container.decode(String.self, forKey: .instruction)

        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for key in dynamicContainer.allKeys {
            if key.stringValue.contains(CodingKeys.ingredient.rawValue) {
                let ingredient = try? dynamicContainer.decode(String.self, forKey: key)
                let number = Int(key.stringValue.components(
                    separatedBy: .decimalDigits.inverted
                ).joined()) ?? 0

                let measureKey = DynamicCodingKeys(
                    stringValue: CodingKeys.measure.rawValue + "\(number)"
                )

                var measure: String? = nil
                if let key = measureKey {
                    measure = try? dynamicContainer.decode(String.self, forKey: key)
                }
                guard let ingredient = ingredient else { continue }
                ingredients.append(.init(name: ingredient, measure: measure))
            }
        }
    }

}

extension Drink {
    
    static func == (lhs: Drink, rhs: Drink) -> Bool {
        lhs.id == rhs.id
    }
}
