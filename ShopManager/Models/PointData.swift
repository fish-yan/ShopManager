//
//  StarData.swift
//  ShopManager
//
//  Created by 张旭 on 3/3/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

import UIKit

@objc class PointData: NSObject {

    @objc class StarData: NSObject {

        var highTimesHighConsump: String!

        var highTimesLowConsump: String!

        var lowTimesHighConsump: String!

        var lowTimesLowConsump: String!

        init (hh: Int, hl: Int, lh: Int, ll: Int) {
            highTimesLowConsump = String(format: "%ld", hl)
            highTimesHighConsump = String(format: "%ld", hh)
            lowTimesHighConsump = String(format: "%ld", lh)
            lowTimesLowConsump = String(format: "%ld", ll)
        }
    }

    static func dataWithDict(result: NSDictionary) -> StarData {
        let data = StarData(
            hh: result.objectForKey("HighTimesHighConsump")?.integerValue ?? 0,
            hl: result.objectForKey("HighTimesLowConsump")?.integerValue ?? 0,
            lh: result.objectForKey("LowTimesHighConsump")?.integerValue ?? 0,
            ll: result.objectForKey("LowTimesLowConsump")?.integerValue ?? 0
        )
        return data
    }

}
