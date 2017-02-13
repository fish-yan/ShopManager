//
//  WashCarAnalyseVM.m
//  ShopManager
//
//  Created by 张旭 on 22/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "WashCarAnalyseVM.h"

@implementation WashCarAnalyseItemVM

@end

@interface WashCarAnalyseVM ()

@property (strong, nonatomic) NSMutableArray<WashCarAnalyseItemVM *> *itemList;

@end

@implementation WashCarAnalyseVM

- (NSMutableArray<WashCarAnalyseItemVM *> *)itemList {
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
	[parameters setObject:self.startDate forKey:@"beginTime"];
	[parameters setObject:self.endDate forKey:@"endTime"];

	[self.sessionManager POST:@"getWashCarNum.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			[self.itemList removeAllObjects];
			self.totalMoney = 0;
			self.totalCount = 0;
			NSArray *dataList = response[@"data"];
			for (NSDictionary *dict in dataList) {
				WashCarAnalyseItemVM *item = [[WashCarAnalyseItemVM alloc] init];
				item.source = dict[@"saletype"];
				item.money = [dict[@"sumMoney"] doubleValue];
				item.count = [dict[@"carNum"] integerValue];
				self.totalMoney += item.money;
				self.totalCount += item.count;
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
	for (WashCarAnalyseItemVM *item in self.listDataSource) {
		jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"starList.push(new PieItem('%@', %.2f));", item.source, item.money]];
	}
	jsStr = [jsStr stringByAppendingString:@"setPieData(starList, null, '金额', '元');"];
	return jsStr;
}

@end
