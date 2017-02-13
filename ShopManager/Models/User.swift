//
//  User.swift
//  ShopManager
//
//  Created by 张旭 on 3/2/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

import UIKit

@objc class User: NSObject {
    static let sharedUser = User()

	var userName: String! = ""

    var storeID: String! = ""

    var storeName: String! = ""

	var companyID: String! /*{
		get {
			return "402883c0434365a7014346c7cc6f5e65"
		}
		set {
			self.companyID = newValue
		}
	}*/

	var companyName: String! /*{
		get {
			return "苏州名骏百盛连锁汽车门店"
		}
		set {
			self.companyName = newValue
		}
	}*/

    var positions: String! = ""

	var userID: String! /*{
		get {
			return "297edeb34c6a6228014c6d8c4cdd0817"
		}
		set {
			self.userID = newValue
		}
	}*/

	var token: String! /*{
		get {
			return "0F51664319D6F4F77A966EB8BA8DA2B7"
		}
		set {
			self.token = newValue
		}
	}*/

    func showName() -> String {
        if positions == "1" {
            return userName + "(老板)"
        }
        return userName + "(店长)"
    }

    func isBoss() -> Bool {
        return positions == "1"
    }

    func configureWithResult(dict: NSDictionary!) {
        userName = dict["UserName"] as? String
        storeID = dict["StoreId"] as? String
        storeName = dict["StoreName"] as? String
        companyID = dict["CompanyId"] as? String
        companyName = dict["CompanyName"] as? String
        positions = dict["Positions"] as? String
        userID = dict["UserId"] as? String
        token = dict["Token"] as? String
    }

}
