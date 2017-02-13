//
//  PurchaseStockVM.m
//  ShopManager
//
//  Created by 张旭 on 07/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "PurchaseStockVM.h"

@implementation PurchaseStockChartItemVM

@end

@interface PurchaseStockVM ()

@property (strong, nonatomic) NSMutableArray<PurchaseStockChartItemVM *> *chartItemList;

@end

@implementation PurchaseStockVM

- (NSMutableArray<PurchaseStockChartItemVM *> *)chartItemList {
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

- (void)chartRequestWithCompletion:(void (^)(BOOL, NSString *, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"companyID"];
	//[parameters setObject:@"402883c0434365a7014346c7cc6f5e65" forKey:@"companyID"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"storeId"];
	}
	[parameters setObject:self.startDate forKey:@"beginTime"];
	[parameters setObject:self.endDate forKey:@"endTime"];

	[self.sessionManager POST:@"getReportMain.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *chartData = response[@"data"];
			[self.chartItemList removeAllObjects];
			for (NSDictionary *chart in chartData) {
				PurchaseStockChartItemVM *item = [[PurchaseStockChartItemVM alloc] init];
				item.date = chart[@"date"];
				item.purchaseCount = [chart[@"cg"] doubleValue];
				item.sumPurchaseCount = [chart[@"ljcg"] doubleValue];
				item.stockCount = [chart[@"kc"] doubleValue];
				item.dueCount = [chart[@"yf"] doubleValue];
				[self.chartItemList addObject:item];
			}
			self.chartDataSource = [self.chartItemList copy];
			self.purchaseCount = self.chartDataSource.lastObject.purchaseCount;
			self.sumPurchaseCount = self.chartDataSource.lastObject.sumPurchaseCount;
			self.stockCount = self.chartDataSource.lastObject.stockCount;
			self.dueCount = self.chartDataSource.lastObject.dueCount;
			NSString *jsStr = [self jsStr];
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

- (NSString *)jsStr {
	NSString *jsStr = @"";
	NSString *data1 = @"";
	NSString *data2 = @"";
	NSString *data3 = @"";
	NSString *data4 = @"";
	for (PurchaseStockChartItemVM *item in self.chartItemList) {
		data1 = [data1 stringByAppendingString:[NSString stringWithFormat:@"%.2f,", item.purchaseCount]];
		data2 = [data2 stringByAppendingString:[NSString stringWithFormat:@"%.2f,", item.sumPurchaseCount]];
		data3 = [data3 stringByAppendingString:[NSString stringWithFormat:@"%.2f,", item.stockCount]];
		data4 = [data4 stringByAppendingString:[NSString stringWithFormat:@"%.2f,", item.dueCount]];
	}
	data1 = [data1 substringToIndex:data1.length-1];
	data2 = [data2 substringToIndex:data2.length-1];
	data3 = [data3 substringToIndex:data3.length-1];
	data4 = [data4 substringToIndex:data4.length-1];
	NSArray<NSString *> *dateFragment = [self.startDate componentsSeparatedByString:@"-"];
	jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"setFourAreaPeriodData('%@', '%@', '%@', '%@', %zd, %zd, %zd, '元', 2)", data1, data2, data3, data4, [dateFragment[0] integerValue], [dateFragment[1] integerValue], [dateFragment[2] integerValue]]];
	return jsStr;
}

@end
