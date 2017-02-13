//
//  CardAnalyseDetailVM.m
//  ShopManager
//
//  Created by 张旭 on 20/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "CardAnalyseDetailVM.h"

@implementation CardAnalyseDetailItemVM

@end

@interface CardAnalyseDetailVM ()

@property (strong, nonatomic) NSMutableArray<CardAnalyseDetailItemVM *> *itemList;

@end

@implementation CardAnalyseDetailVM

- (NSMutableArray<CardAnalyseDetailItemVM *> *)itemList {
	if (_itemList == nil) {
		_itemList = [NSMutableArray array];
	}
	return _itemList;
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

- (void)listRequestWithCompletion:(void (^)(BOOL, NSString *, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"companyID"];
	//[parameters setObject:@"402883c0434365a7014346c7cc6f5e65" forKey:@"companyID"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"storeId"];
	}
	[parameters setObject:self.selectedDate forKey:@"setttime"];

	[self.sessionManager POST:@"getCardCount4Details.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			[self.itemList removeAllObjects];
			self.totalMoney = 0;
			self.totalCost = 0;
			self.totalProfit = 0;
			NSArray *dataList = response[@"data"];
			for (NSDictionary *dict in dataList) {
				CardAnalyseDetailItemVM *item = [[CardAnalyseDetailItemVM alloc] init];
				item.name = dict[@"serviceType"];
				item.money = [dict[@"totalPrice"] doubleValue];
				item.cost = [dict[@"costPrice"] doubleValue];
				item.profit = item.money-item.cost;
				self.totalMoney += item.money;
				self.totalCost += item.cost;
				self.totalProfit += item.profit;
				[self.itemList addObject:item];
			}
			self.listDataSource = [self.itemList copy];
			NSString *jsStr = [self jsStr];
			if (complete) {
				complete(YES, jsStr, nil);
			}
		} else {
			[self.itemList removeAllObjects];
			self.listDataSource = nil;
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
	NSString *jsStr = @"var starList = [];";
	for (CardAnalyseDetailItemVM *item in self.listDataSource) {
		jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"starList.push(new PieItem('%@', %.2f));", item.name, item.money]];
	}
	jsStr = [jsStr stringByAppendingString:@"setPieData(starList, null, '销售金额', '元');"];
	return jsStr;
}


@end
