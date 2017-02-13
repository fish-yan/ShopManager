//
//  SaleAnalyseVM.m
//  ShopManager
//
//  Created by 张旭 on 08/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "SaleAnalyseVM.h"

@implementation SaleAnalyseItemVM

@end

@implementation SaleAnalyseChartItemVM

@end

@interface SaleAnalyseVM ()

@property (strong, nonatomic) NSMutableArray<SaleAnalyseItemVM *> *itemList;

@property (strong, nonatomic) NSMutableArray<SaleAnalyseChartItemVM *> *chartItemList;
@property (strong, nonatomic) NSMutableArray<SaleAnalyseChartItemVM *> *chartItemList2;

@end

@implementation SaleAnalyseVM

- (NSMutableArray<SaleAnalyseItemVM *> *)itemList {
	if (_itemList == nil) {
		_itemList = [NSMutableArray array];
	}
	return _itemList;
}

- (NSMutableArray<SaleAnalyseChartItemVM *> *)chartItemList {
	if (_chartItemList == nil) {
		_chartItemList = [NSMutableArray array];
	}
	return _chartItemList;
}

- (NSMutableArray<SaleAnalyseChartItemVM *> *)chartItemList2 {
	if (_chartItemList2 == nil) {
		_chartItemList2 = [NSMutableArray array];
	}
	return _chartItemList2;
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

- (CGFloat)goodsRatio {
	if (self.totalMoney == 0) {
		return 0;
	}
	return self.goodsMoney/self.totalMoney*100;
}

- (CGFloat)productRatio {
	if (self.totalMoney == 0) {
		return 0;
	}
	return self.productMoney/self.totalMoney*100;
}

- (CGFloat)projectRatio {
	if (self.totalMoney == 0) {
		return 0;
	}
	return self.projectMoney/self.totalMoney*100;
}

- (CGFloat)cardRatio {
	if (self.totalMoney == 0) {
		return 0;
	}
	return self.cardMoney/self.totalMoney*100;
}

- (void)firstRequestWithCompletion:(void (^)(BOOL, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"companyID"];
	//[parameters setObject:@"402883c0434365a7014346c7cc6f5e65" forKey:@"companyID"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"storeId"];
	}
	[parameters setObject:self.selectedDate forKey:@"settTime"];

	[self.sessionManager POST:@"getSalesReportListOne.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *firstList = response[@"data"];
			for (NSDictionary *item in firstList) {
				if (item[@"itemstyle"] == [NSNull null]) {
					continue;
				}
				if ([item[@"itemstyle"] isEqualToString:@"卡销售"]) {
					self.cardMoney = [item[@"taxsaletotal"] doubleValue];
				} else if ([item[@"itemstyle"] isEqualToString:@"配件"]) {
					self.productMoney = [item[@"taxsaletotal"] doubleValue];
				} else if ([item[@"itemstyle"] isEqualToString:@"商品"]) {
					self.goodsMoney = [item[@"taxsaletotal"] doubleValue];
				} else if ([item[@"itemstyle"] isEqualToString:@"项目"]) {
					self.projectMoney = [item[@"taxsaletotal"] doubleValue];
				}
			}
			if (complete) {
				complete(YES, nil);
			}
		} else {
			if (complete) {
				complete(NO, response[Message]);
			}
		}
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"%@", error.localizedDescription);
		if (failure) {
			failure();
		}
	}];
}

- (void)secondRequestWithCompletion:(void (^)(BOOL, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	if (self.type == 0) {
		[parameters setObject:@"one" forKey:@"type"];
	} else if (self.type == 1) {
		[parameters setObject:@"two" forKey:@"type"];
	}
	[parameters setObject:[User sharedUser].companyID forKey:@"companyID"];
	//[parameters setObject:@"402883c0434365a7014346c7cc6f5e65" forKey:@"companyID"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"storeId"];
	}
	[parameters setObject:self.selectedDate forKey:@"settTime"];

	[self.sessionManager POST:@"getSalesReportListTwo.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *listData = response[@"data"];
			[self.itemList removeAllObjects];
			for (NSDictionary *dict in listData) {
				SaleAnalyseItemVM *item = [[SaleAnalyseItemVM alloc] init];
				if (self.type == 0) {
					item.name = dict[@"costobjectname"] == [NSNull null] ? @"" : dict[@"costobjectname"];
					item.count = [dict[@"taxsaletotal"] doubleValue];
					if (self.totalMoney == 0) {
						item.percent = 0;
					} else {
						item.percent = item.count/self.totalMoney*100;
					}
				} else if (self.type == 1) {
					item.name = dict[@"deptname"] == [NSNull null] ? @"" : dict[@"deptname"];
					item.count = [dict[@"taxsaletotal"] doubleValue];
					if (self.totalMoney == 0) {
						item.percent = 0;
					} else {
						item.percent = item.count/self.totalMoney*100;
					}
				}
				[self.itemList addObject:item];
			}
			self.listDataSource = [self.itemList copy];
			if (complete) {
				complete(YES, nil);
			}
		} else {
			[self.itemList removeAllObjects];
			self.listDataSource = nil;
			if (complete) {
				complete(NO, response[Message]);
			}
		}
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"%@", error.localizedDescription);
		if (failure) {
			failure();
		}
	}];
}

- (void)chartRequestWithCompletion:(void (^)(BOOL, NSString *, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"companyID"];
	//[parameters setObject:@"402883c0434365a7014346c7cc6f5e65" forKey:@"companyID"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"storeId"];
	}
	[parameters setObject:self.startDate forKey:@"beginTime"];
	[parameters setObject:self.endDate forKey:@"endTime"];

	[self.sessionManager POST:@"getSalesReportLine.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *chartData = response[@"data"];
			[self clearList];
			[self.chartItemList removeAllObjects];
			for (NSDictionary *chart in chartData) {
				SaleAnalyseChartItemVM *item = [[SaleAnalyseChartItemVM alloc] init];
				item.date = chart[@"settTime"];
				item.money = [chart[@"taxsaletotal"] doubleValue];
				[self.chartItemList addObject:item];
			}
			self.chartDataSource = [self.chartItemList copy];
			if (self.isSelected) {
				NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
				[parameters setObject:[User sharedUser].companyID forKey:@"companyID"];
				//[parameters setObject:@"402883c0434365a7014346c7cc6f5e65" forKey:@"companyID"];
				if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
					[parameters setObject:self.storeId forKey:@"storeId"];
				}
				NSArray<NSString *> *stringList1 = [self.startDate componentsSeparatedByString:@"-"];
				NSArray<NSString *> *stringList2 = [self.endDate componentsSeparatedByString:@"-"];
				NSString *startDate = [NSString stringWithFormat:@"%ld-%@-%@", [stringList1[0] integerValue]-1, stringList1[1], stringList1[2]];
				NSString *endDate = [NSString stringWithFormat:@"%ld-%@-%@", [stringList2[0] integerValue]-1, stringList2[1], stringList2[2]];
				[parameters setObject:startDate forKey:@"beginTime"];
				[parameters setObject:endDate forKey:@"endTime"];
				[self.sessionManager POST:@"getSalesReportLine.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
					NSLog(@"%@", responseObject);
					NSDictionary *response = responseObject;
					if ([response[@"type"] integerValue] == 1) {
						NSArray *chartData = response[@"data"];
						[self.chartItemList2 removeAllObjects];
						for (NSDictionary *chart in chartData) {
							SaleAnalyseChartItemVM *item = [[SaleAnalyseChartItemVM alloc] init];
							item.date = chart[@"settTime"];
							item.money = [chart[@"taxsaletotal"] doubleValue];
							[self.chartItemList2 addObject:item];
						}
						self.chartDataSource2 = [self.chartItemList2 copy];
						NSString *jsStr = [self jsStr];
						if (complete) {
							complete(YES, jsStr, nil);
						}
					} else {
						[self clearList];
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
			} else {
				NSString *jsStr = [self jsStr];
				if (complete) {
					complete(YES, jsStr, nil);
				}
			}
		} else {
			[self clearList];
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

- (NSString *)jsStr {
	NSString *jsStr = @"var stringList = \"";
	for (NSInteger i = 0; i < self.chartDataSource.count; ++i) {
		SaleAnalyseChartItemVM *item = self.chartDataSource[i];
		jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"%.2f,", item.money]];
	}
	jsStr = [jsStr substringToIndex:jsStr.length-1];
	jsStr = [jsStr stringByAppendingString:@"\";"];
	if (self.isSelected) {
		jsStr = [jsStr stringByAppendingString:@"var stringList2 = \""];
		for (NSInteger i = 0; i < self.chartDataSource2.count; ++i) {
			SaleAnalyseChartItemVM *item = self.chartDataSource2[i];
			jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"%.2f,", item.money]];
		}
		jsStr = [jsStr substringToIndex:jsStr.length-1];
		jsStr = [jsStr stringByAppendingString:@"\";"];
	} else {
		jsStr = [jsStr stringByAppendingString:@"var stringList2 = null;"];
	}
	NSArray<NSString *> *dateFragment = [self.startDate componentsSeparatedByString:@"-"];
	jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"setAreaPeriodData(stringList, stringList2, %zd, %zd, %zd,'营业额', '元', 2);", [dateFragment[0] integerValue], [dateFragment[1] integerValue], [dateFragment[2] integerValue]]];
	return jsStr;
}

- (void)clearList {
	self.totalMoney = 0;
	self.goodsMoney = 0;
	self.productMoney = 0;
	self.projectMoney = 0;
	self.cardMoney = 0;
	[self.itemList removeAllObjects];
	self.listDataSource = nil;
}

@end
