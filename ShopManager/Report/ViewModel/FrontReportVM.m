//
//  FrontReportVM.m
//  ShopManager
//
//  Created by 张旭 on 10/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "FrontReportVM.h"

@implementation FrontReportItemVM

@end

@implementation FrontReportChartItemVM

@end

@interface FrontReportVM ()

@property (strong, nonatomic) NSMutableArray<FrontReportItemVM *> *itemList;
@property (strong, nonatomic) NSMutableArray<FrontReportChartItemVM *> *chartItemList;

@end

@implementation FrontReportVM

- (NSMutableArray<FrontReportItemVM *> *)itemList {
	if (_itemList == nil) {
		_itemList = [NSMutableArray array];
		NSArray *titleArray = @[@"商品零售单", @"项目结算单", @"洗车单", @"销售退货单", @"项目施工单", @"卡发售", @"卡充值", @"销售红冲单", @"销售补缴单", @"退卡单"];
		for (NSInteger i = 0; i < titleArray.count; ++i) {
			FrontReportItemVM *item = [[FrontReportItemVM alloc] init];
			item.name = titleArray[i];
			[_itemList addObject:item];
		}
	}
	return _itemList;
}

- (NSMutableArray<FrontReportChartItemVM *> *)chartItemList {
	if (_chartItemList == nil) {
		_chartItemList = [NSMutableArray array];
	}
	return _chartItemList;
}

- (NSString *)showTime {
	return [NSString stringWithFormat:@"%@~%@", self.startDate, self.endDate];
}

- (NSString *)startDate {
	if (_startDate == nil) {
		NSDate *date = [NSDate date];
		_startDate = [NSString stringWithFormat:@"%zd-%02zd-%02zd", date.year, date.month, 1];
	}
	return _startDate;
}

- (NSString *)endDate {
	if (_endDate == nil) {
		NSDate *date = [NSDate date];
		NSInteger days = [date daysInMonth];
		_endDate = [NSString stringWithFormat:@"%zd-%02zd-%02zd", date.year, date.month, days];
	}
	return _endDate;
}

- (void)firstRequestWithCompletion:(void (^)(BOOL, NSString *, NSString *, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"companyID"];
	//[parameters setObject:@"402883c0434365a7014346c7cc6f5e65" forKey:@"orgId"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"storeId"];
	}
	[parameters setObject:self.startDate forKey:@"beginTime"];
	[parameters setObject:self.endDate forKey:@"endTime"];

	[self.sessionManager POST:@"getBusinessdayReport.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {

			self.totalysCount = 0;
			self.totalxkCount = 0;
			self.totaltxkCount = 0;
			self.totalgzCount = 0;
			self.totaltgzCount = 0;
			self.totalysxkCount = 0;
			self.totalysgzCount = 0;
			self.totalcysCount = 0;

			NSArray *listData = response[@"data"];
			for (NSDictionary *dict in listData) {
				NSString *businessType = dict[@"businessType"];
				NSInteger index = [[businessType componentsSeparatedByString:@"."][0] integerValue]-1;
				if (index >= 0 && index <10) {
					FrontReportItemVM *item = self.itemList[index];
					item.xkCount = [dict[@"cashSales"] doubleValue];
					item.txkCount = [dict[@"cashBack1"] doubleValue];
					item.gzCount = [dict[@"creditSales"] doubleValue];
					item.tgzCount = [dict[@"cashBack2"] doubleValue];
					item.cysCount = [dict[@"redAdvance1"] doubleValue];
					item.ysxkCount = [dict[@"theCash"] doubleValue];
					item.ysgzCount = [dict[@"recoveryBill"] doubleValue];
					self.yskCount = [dict[@"prePayment"] doubleValue];
					self.bxyskCount = [dict[@"receivables"] doubleValue];
					self.bxyskCount2 = [dict[@"collectMoney"] doubleValue];
					self.bxcysCount = [dict[@"redAdvance2"] doubleValue];

					self.totalysCount += (item.xkCount+item.gzCount);
					self.totalxkCount += item.xkCount;
					self.totaltxkCount += item.txkCount;
					self.totalgzCount += item.gzCount;
					self.totaltgzCount += item.tgzCount;

					self.totalysxkCount += item.ysxkCount;
					self.totalysgzCount += item.ysgzCount;
					self.totalcysCount += item.cysCount;

					if (item.xkCount+item.gzCount >= 0) {
						item.firstColor = [UIColor blackColor];
					} else {
						item.firstColor = UIColorFromRGB(0x39a63b);
					}
					if (item.ysxkCount-item.cysCount >= 0) {
						item.secondColor = [UIColor blackColor];
					} else {
						item.secondColor = UIColorFromRGB(0x39a63b);
					}
				}
			}
			self.totalysCount2  = self.totalysxkCount+self.yskCount-self.totalcysCount+self.bxyskCount+self.bxyskCount2-self.bxcysCount;
			self.listDataSource = [self.itemList copy];
			NSString *jsStr1 = [self jsStr1];
			NSString *jsStr2 = [self jsStr2];
			if (complete) {
				complete(YES, jsStr1, jsStr2, nil);
			}
		} else {
			if (complete) {
				complete(NO, nil, nil, response[Message]);
			}
		}
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"%@", error.localizedDescription);
		if (failure) {
			failure();
		}
	}];
}

- (void)secondRequestWithCompletion:(void (^)(BOOL, NSString *, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"companyID"];
	//[parameters setObject:@"402883c0434365a7014346c7cc6f5e65" forKey:@"orgId"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"storeId"];
	}
	[parameters setObject:self.startDate forKey:@"beginTime"];
	[parameters setObject:self.endDate forKey:@"endTime"];

	[self.sessionManager POST:@"getBusinessdayReportTwo.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *dataList = response[@"data"];
			self.totalskCount = 0;
			for (NSDictionary *dict in dataList) {
				FrontReportChartItemVM *item = [[FrontReportChartItemVM alloc] init];
				item.type = dict[@"payment"];
				item.money = [dict[@"ReceiveMoney"] doubleValue];
				self.totalskCount += item.money;
				[self.chartItemList addObject:item];
			}
			self.chartDataSource = [self.chartItemList copy];
			NSString *jsStr = [self jsStr3];
			if (complete) {
				complete(YES, jsStr, nil);
			}
		} else {
			if (complete) {
				complete(NO, nil, response[Message]);
			}
		}
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"%@", error.localizedDescription);
		if (failure) {
			failure();
		}
	}];
}

- (NSString *)jsStr1 {
	NSString *jsStr = @"var starList = [];";
	for (FrontReportItemVM *item in self.listDataSource) {
		jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"starList.push(new PieItem('%@', %.2f));", item.name, item.xkCount+item.gzCount]];
	}
	jsStr = [jsStr stringByAppendingString:@"setPieData(starList, ['#6495D6', '#8ED267', '#459B69', '#F87562', '#F8B966', '#B0693A', '#7E83D6', '#EB7475', '#C680D7', '#969391'], '金额', '元');"];
	return jsStr;
}

- (NSString *)jsStr2 {
	NSString *jsStr = @"var starList = [];";
	for (FrontReportItemVM *item in self.listDataSource) {
		jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"starList.push(new PieItem('%@', %.2f));", item.name, item.ysxkCount-item.cysCount]];
	}
	jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"starList.push(new PieItem('预售款单', %.2f));", self.yskCount]];
	jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"starList.push(new PieItem('保险', %.2f));", self.bxyskCount+self.bxyskCount2-self.bxcysCount]];
	jsStr = [jsStr stringByAppendingString:@"setPieData(starList, ['#6495D6', '#8ED267', '#459B69', '#F87562', '#F8B966', '#B0693A', '#7E83D6', '#EB7475', '#C680D7', '#969391', '#DE7D38', '#67D4DA'], '金额', '元');"];
	return jsStr;
}

- (NSString *)jsStr3 {
	NSString *jsStr = @"var starList = [];";
	for (FrontReportChartItemVM *item in self.chartDataSource) {
		jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"starList.push(new PieItem('%@', %.2f));", item.type, item.money]];
	}
	jsStr = [jsStr stringByAppendingString:@"setPieData(starList, ['#6495D6', '#8ED267', '#459B69', '#F87562', '#F8B966', '#B0693A', '#7E83D6', '#EB7475', '#C680D7', '#969391', '#DE7D38', '#67D4DA', '#F6A623', '#F8E81C', '#8B572A', '#7ED321', '#417505', '#4990E2', '#B8E986', '#F1576A', 'D16C62', '#827C8B', '#F2AA43', '#C28155', '#574C8C', '#DCB995'],  '金额', '元');"];
	return jsStr;
}

@end
