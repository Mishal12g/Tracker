//
//  Analysis.swift
//  Tracker
//
//  Created by mihail on 07.03.2024.
//

import UIKit
import YandexMobileMetrica

final class Analysis {
    static func setup() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "d1430b9a-6255-433f-bb87-78e27bada5e1") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    static func report(event: Event, screen: Screen, item: Item? = nil) {
        var params: [AnyHashable: Any] = ["screen": screen.rawValue]
        if event == .click, let item {
            params["item"] = item.rawValue
        }
        
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params) { error in
            print("REPORT ERROR: \(error.localizedDescription)")
        }
    }
}
