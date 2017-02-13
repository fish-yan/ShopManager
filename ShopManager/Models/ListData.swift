//
//  HomeData.swift
//  ShopManager
//
//  Created by 张旭 on 3/3/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

import UIKit

@objc class ListData: NSObject {

    @objc class CustomAnaly: NSObject {
        static let title = User.sharedUser.companyID != "402883c0434365a7014346c7cc6f5e65" ?
            ["领养客户量", "基盘客户量", "流失客户量", "准流失客户量", "新增客户量", "客户服务量", "微信客户量"] :
            ["领养客户量", "基盘客户量", "金骏客户量", "流失客户量", "准流失客户量", "新增客户量", "客户服务量", "微信客户量"]
        var customAdoptTotal: Int!
        var customBaseTotal: Int!
        var customJinJunTotal: Int!
        var customLostTotal: Int!
        var customLoseTotal: Int!
        var customNewTotal: Int!
        var customServiceTotal: Int!
        var customWXTotal: Int!
        let count = User.sharedUser.companyID != "402883c0434365a7014346c7cc6f5e65" ? 7 : 8

        func objectAtIndex(index: Int) -> Int {
            var indexCopy = index
            if User.sharedUser.companyID != "402883c0434365a7014346c7cc6f5e65" && index >= 2 {
                indexCopy += 1
            }
            switch indexCopy {
            case 0:
                return customAdoptTotal
            case 1:
                return customBaseTotal
            case 2:
                return customJinJunTotal
            case 3:
                return customLostTotal
            case 4:
                return customLoseTotal
            case 5:
                return customNewTotal
            case 6:
                return customServiceTotal
            case 7:
                return customWXTotal
            default:
                return 0
            }
        }
    }

    @objc class Store: NSObject {
        var storeID: String!
        var storeName: String!
        var storeState = "0"
    }

    @objc class DeptTransfer: NSObject {
        var deptName: String!
        var transferPer: String!
    }

    @objc class SheQuList: NSObject {
        var idStr: String!
        var addDate: String!
        var brief: String!
        var clickNum: NSString!
        var title: String!
        var replyNum: String!
    }

    @objc class Answer: NSObject {
        var userName: String!
        var content: String!
        var addDate: String!
    }

    @objc class BBSDetail: NSObject {
        var title: String!
        var addDate: String!
        var brief: String!
        var imageAddress: String!
        var answerList: Array<Answer>!
    }

    static func homeDataWithDict(result: NSDictionary) -> Array<Int> {
        var data = [Int] ()
        data.append(result.objectForKey("ComeInCounts")?.integerValue ?? 0)
        data.append(result.objectForKey("RepairsCounts")?.integerValue ?? 0)
        data.append(result.objectForKey("CustomNewCounts")?.integerValue ?? 0)
        data.append(result.objectForKey("CustomLoseCounts")?.integerValue ?? 0)
        data.append(result.objectForKey("BirthdayCounts")?.integerValue ?? 0)
        data.append(result.objectForKey("CarInsuretanceCounts")?.integerValue ?? 0)
        return data
    }

    static func saleDataWithDict(result: NSDictionary) -> Array<Double> {
        var data = [Double] ()
        data.append(result.objectForKey("SaleTotal")?.doubleValue ?? 0)
        //data.append(result.objectForKey("ProfitTotal")?.doubleValue ?? 0)
        data.append(result.objectForKey("WashCarTotal")?.doubleValue ?? 0)
        data.append(result.objectForKey("BeautyTotal")?.doubleValue ?? 0)
        data.append(result.objectForKey("DecorateTotal")?.doubleValue ?? 0)
        data.append(result.objectForKey("ReapirTotal")?.doubleValue ?? 0)
        data.append(result.objectForKey("TireTotal")?.doubleValue ?? 0)
        data.append(result.objectForKey("SprayTotal")?.doubleValue ?? 0)
        data.append(result.objectForKey("SagTotal")?.doubleValue ?? 0)
        data.append(result.objectForKey("SoundTotal")?.doubleValue ?? 0)
        data.append(result.objectForKey("CardTotal")?.doubleValue ?? 0)
        data.append(result.objectForKey("CarInsureTanceTotal")?.doubleValue ?? 0)
        return data
    }

    static func starDataWithArray(result: NSArray) -> Array<Int> {
        var data = Array<Int> (count: 11, repeatedValue: 0)
        for item in result {
            guard let doubleIndex: Double! = (item.objectForKey("star")?.doubleValue)!/0.5 else {
                continue
            }
            let index = Int(doubleIndex)
            let value = item.objectForKey("customtotal")?.integerValue ?? 0
            data [index] = value
        }
        return data
    }

    static func customAnalyDataWithDict(result: NSDictionary) -> CustomAnaly {
        let data = CustomAnaly()
        data.customAdoptTotal = result.objectForKey("CustomAdoptTotal")?.integerValue ?? 0
        data.customBaseTotal = result.objectForKey("CustomBaseTotal")?.integerValue ?? 0
        data.customJinJunTotal = result.objectForKey("CustomJinJunTotal")?.integerValue ?? 0
        data.customLostTotal = result.objectForKey("CustomLostTotal")?.integerValue ?? 0
        data.customLoseTotal = result.objectForKey("CustomLoseTotal")?.integerValue ?? 0
        data.customNewTotal = result.objectForKey("CustomNewTotal")?.integerValue ?? 0
        data.customServiceTotal = result.objectForKey("CustomServiceTotal")?.integerValue ?? 0
        data.customWXTotal = result.objectForKey("CustomWXTotal")?.integerValue ?? 0
        return data
    }

    static func storeDataWithArray(result: NSArray) -> Array<Store> {
        var data = [Store] ()
        for item in result {
            if let dict = item as? NSDictionary {
                if let storeID = dict["StoreId"] as? String {
                    if let storeName = dict["StoreName"] as? String {
                        let store = Store()
                        store.storeID = storeID
                        store.storeName = storeName
                        data.append(store)
                    }
                }
            }
        }
        return data
    }

    static func deptTransferDataWithArray(result: NSArray) -> Array<DeptTransfer> {
        var data = [DeptTransfer] ()
        for item in result {
            if let dict = item as? NSDictionary {
                if let deptName = dict["DeptName"] as? String {
                    if let transferPer = dict["TransferPer"] as? String {
                        let deptTransfer = DeptTransfer()
                        deptTransfer.deptName = deptName
                        deptTransfer.transferPer = transferPer
                        data.append(deptTransfer)
                    }
                }
            }
        }
        return data
    }

    static func comInPageDataWithDict(result: NSDictionary) -> Array<String> {
        var data = [String] ()
        let washCarCounts = result.objectForKey("WashCarCounts") as? String
        data.append(washCarCounts ?? "0")
        let repairCounts = result.objectForKey("RepairsCounts") as? String
        data.append(repairCounts ?? "0")
        let previewCounts = result.objectForKey("PreviewCounts") as? String
        data.append(previewCounts ?? "0")
        return data
    }

    static func shequListDataWithArray(result: NSArray) -> Array<SheQuList> {
        var data = [SheQuList] ()
        for item in result {
            if let dict = item as? NSDictionary {
                if let idStr = dict["Id"] as? String,
                    addDate = dict["AddDate"] as? String,
                    brief = dict["Brief"] as? String,
                    clickNum = dict["ClickNum"] as? String,
                    title = dict["Title"] as? String,
                    replyNum = dict["ReplayNum"] as? String {
                        let shequitem = SheQuList()
                        shequitem.idStr = idStr
                        shequitem.addDate = addDate
                        shequitem.brief = brief
                        shequitem.clickNum = clickNum
                        shequitem.title = title
                        shequitem.replyNum = replyNum
                        data.append(shequitem)
                }
            }
        }
        return data
    }

    static func bbsDetailWithDict(result: NSDictionary) -> BBSDetail {
        let bbsDetail = BBSDetail()
        if let title = result["Title"] as? String,
            addDate = result["AddDate"] as? String,
            brief = result["Brief"] as? String,
            answerArray = result["AnswerList"] as? NSArray {
                bbsDetail.title = title
                bbsDetail.addDate = addDate
                bbsDetail.brief = brief
                bbsDetail.answerList = [Answer] ()
                for item in answerArray {
                    if let dict = item as? NSDictionary {
                        if let userName = dict["UserName"] as? String,
                            addDate = dict["AddDate"] as? String,
                            content = dict["Content"] as? String {
                                let answer = Answer()
                                answer.userName = userName
                                answer.addDate = addDate
                                answer.content = content
                                bbsDetail.answerList.append(answer)
                        }
                    }
                }
        }
//        let Regrex = try!
//            NSRegularExpression(pattern:
//                "<img\\s[^>]*?src\\s*=\\s*['\\\"]([^'\\\"]*?)['\\\"][^>]*?>",
//                options: .CaseInsensitive)
//        let match = Regrex.firstMatchInString(bbsDetail.brief as String, options: [],
//            range: NSMakeRange(0, bbsDetail.brief.length))
//        bbsDetail.imageAddress = bbsDetail.brief.substringWithRange((match?.range)!)
        return bbsDetail
    }
    
    @objc class CostItem: NSObject {
        var costObjectName: String! = ""
        var taxSaleTotal: String! = ""
        var taxCostTotal: String! = ""
        var taxProfitTotal: String! = ""
    }
    
    static func costListWithResult(result: NSArray) -> Array<CostItem> {
        var data = [CostItem] ()
        for item in result {
            if let dict = item as? NSDictionary {
                let costItem = CostItem()
                costItem.costObjectName = (dict["costobjectname"] as? String) ?? ""
                costItem.taxSaleTotal = (dict["taxsaletotal"] as? String) ?? ""
                costItem.taxCostTotal = (dict["taxcosttotal"] as? String) ?? ""
                costItem.taxProfitTotal = (dict["taxprofittotal"] as? String) ?? ""
                data.append(costItem)
            }
        }
        return data
    }
    
    @objc class CostOrderItem: NSObject {
        var saleId: String! = ""
        var mentNo: String! = ""
        var memberName: String! = ""
        var licenNum: String! = ""
        var serviceConsultant: String! = ""
        var orderName: String! = ""
        var taxCostTotal: String! = ""
        var taxProfitTotal: String! = ""
        var taxSaleTotal: String! = ""
        var num: String! = ""
        var itemName: String! = ""
        var itemCode: String! = ""
        var itemSpec: String! = ""
        var itemUnit: String! = ""
        var itemBrand: String! = ""
        var itemType: String! = ""
        var costObjectName: String! = ""
        var deptName: String! = ""
        var createDate: String! = ""
    }
    
    static func costOrderListWithResult(result: NSArray) -> Array<CostOrderItem> {
        var data = [CostOrderItem] ()
        for item in result {
            if let dict = item as? NSDictionary {
                let costOrderItem = CostOrderItem ()
                costOrderItem.saleId = (dict["saleid"] as? String) ?? ""
                costOrderItem.mentNo = (dict["mentno"] as? String) ?? ""
                costOrderItem.memberName = (dict["membername"] as? String) ?? ""
                costOrderItem.licenNum = (dict["licennum"] as? String) ?? ""
                costOrderItem.serviceConsultant = (dict["serviceconsultant"] as? String) ?? ""
                costOrderItem.orderName = (dict["ordername"] as? String) ?? ""
                costOrderItem.taxCostTotal = (dict["taxcosttotal"] as? String) ?? ""
                costOrderItem.taxProfitTotal = (dict["taxprofittotal"] as? String) ?? ""
                costOrderItem.taxSaleTotal = (dict["taxsaletotal"] as? String) ?? ""
                costOrderItem.num = (dict["num"] as? String) ?? ""
                costOrderItem.itemName = (dict["itemname"] as? String) ?? ""
                costOrderItem.itemCode = (dict["itemcode"] as? String) ?? ""
                costOrderItem.itemSpec = (dict["itemspec"] as? String) ?? ""
                costOrderItem.itemUnit = (dict["itemunit"] as? String) ?? ""
                costOrderItem.itemBrand = (dict["itembrand"] as? String) ?? ""
                costOrderItem.itemType = (dict["itemtype"] as? String) ?? ""
                costOrderItem.costObjectName = (dict["costobjectname"] as? String) ?? ""
                costOrderItem.deptName = (dict["deptname"] as? String) ?? ""
                costOrderItem.createDate = (dict["createdate"] as? String) ?? ""
                data.append(costOrderItem)
            }
        }
        return data
    }
    
    @objc class SaleProjectItem: NSObject {
        var projectName: String! = ""
        var projectCode: String! = ""
        var totalPay: Float = 0
    }
    
    @objc class SaleProductItem: NSObject {
        var productSpecification: String! = ""
        var productName: String! = ""
        var productCode: String! = ""
        var amount: Float = 0
        var totalPay: Float = 0
        var brand: String! = ""
    }
    
    @objc class CostOrderDesc: NSObject {
        var mentNo: String! = ""
        var orderName: String! = ""
        var memberName: String! = ""
        var licenNum: String! = ""
        var telNumber: String! = ""
        var billingDate: String! = ""
        var totalPay: Float = 0
        var totalNum: Float = 0
        var status: String! = ""
        var saleProjects = [SaleProjectItem] ()
        var saleProducts = [SaleProductItem] ()
    }
    
    static func costOrderDescWithResult(result: NSDictionary) -> CostOrderDesc {
        let costOrderDesc = CostOrderDesc()
        costOrderDesc.mentNo = (result["MentNo"] as? String) ?? ""
        costOrderDesc.orderName = (result["OrderName"] as? String) ?? ""
        costOrderDesc.memberName = (result["MemberName"] as? String) ?? ""
        costOrderDesc.licenNum = (result["LicenNum"] as? String) ?? ""
        costOrderDesc.telNumber = (result["TelNumber"] as? String) ?? ""
        costOrderDesc.billingDate = (result["BillingDate"] as? String) ?? ""
        costOrderDesc.totalPay = (result["TotalPay"] as? Float) ?? 0
        costOrderDesc.totalNum = (result["TotalNum"] as? Float) ?? 0
        costOrderDesc.status = (result["Status"] as? String) ?? ""
        if let projectArray = result["SaleProjects"] as? NSArray {
            for item in projectArray {
                if let dict = item as? NSDictionary {
                    let saleProjectItem = SaleProjectItem()
                    saleProjectItem.projectName = (dict["ProjectName"] as? String) ?? ""
                    saleProjectItem.projectCode = (dict["ProjectCode"] as? String) ?? ""
                    saleProjectItem.totalPay = (dict["TotalPay"] as? Float) ?? 0
                    costOrderDesc.saleProjects.append(saleProjectItem)
                }
            }
        }
        if let productArray = result["SaleProducts"] as? NSArray {
            for item in productArray {
                if let dict = item as? NSDictionary {
                    let saleProductItem = SaleProductItem()
                    saleProductItem.productSpecification = (dict["ProductSpecification"] as? String) ?? ""
                    saleProductItem.productName = (dict["ProductName"] as? String) ?? ""
                    saleProductItem.productCode = (dict["ProductCode"] as? String) ?? ""
                    saleProductItem.amount = (dict["Amount"] as? Float) ?? 0
                    saleProductItem.totalPay = (dict["TotalPay"] as? Float) ?? 0
                    saleProductItem.brand = (dict["Brand"] as? String) ?? ""
                    costOrderDesc.saleProducts.append(saleProductItem)
                }
            }
        }
        return costOrderDesc
    }
}
