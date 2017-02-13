//
//  SaleTotal.swift
//  ShopManager
//
//  Created by 张旭 on 3/2/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

import UIKit

@objc class AreaData: NSObject {

    @objc class SaleTotalItem: NSObject {

        var dateTime: String!

        var saleTotal: String!

        init(time: String, total: String) {
            dateTime = time
            saleTotal = total
        }
    }

    @objc class ComeInItem: NSObject {

        var dateTime: String!

        var comeInTotal: String!

        init (time: String, total: String) {
            dateTime = time
            comeInTotal = total
        }
    }
    @objc class TransferItem: NSObject {

        var dateTime: String!

        var  transfer: String!

        init (time: String, trans: String) {
            dateTime = time
            transfer = trans
        }
    }

    static func saleTotalWithArray(result: NSArray) -> Array<SaleTotalItem> {
        var dataset = [SaleTotalItem] ()
        for item in result {
            if let dict = item as? NSDictionary {
                if let dateTime = dict["DateTime"] as? String {
                    if let saleTotal = dict["SaleTotal"] as? String {
                        dataset.append(SaleTotalItem(time: dateTime, total: saleTotal))
                    }
                }
            }
        }
        return dataset
    }

    static func comeInWithArray(result: NSArray) -> Array<ComeInItem> {
        var dataset = [ComeInItem] ()
        for item in result {
            if let dict = item as? NSDictionary {
                if let dateTime = dict["DateTime"] as? String {
                    if let comeInTotal = dict["ComeInTotal"] as? String {
                        dataset.append(ComeInItem(time: dateTime, total: comeInTotal))
                    }
                }
            }
        }
        return dataset
    }

    static func transferWithArray(result: NSArray) -> Array<TransferItem> {
        var dataset = [TransferItem] ()
        for item in result {
            if let dict = item as? NSDictionary {
                if let dateTime = dict["DateTime"] as? String {
                    if let transferPer = dict["TransferPer"] as? String {
                        dataset.append(TransferItem(time: dateTime, trans: transferPer))
                    }
                }
            }
        }
        return dataset
    }
}
