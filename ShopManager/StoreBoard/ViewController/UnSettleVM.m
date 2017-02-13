//
//  UnSettleVM.m
//  ShopManager
//
//  Created by 张旭 on 01/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "UnSettleVM.h"

@implementation UnSettleItemVM

- (NSString *)name {
	if (_name == nil) {
		_name = @"";
	}
	return [NSString stringWithFormat:@"客户姓名：%@", _name];
}

- (NSString *)carNum {
	if (_carNum == nil) {
		_carNum = @"";
	}
	return [NSString stringWithFormat:@"车牌号码：%@", _carNum];
}

- (NSString *)phone {
	if (_phone == nil) {
		_phone = @"";
	}
	return [NSString stringWithFormat:@"联系方式：%@", _phone];
}

@end

@implementation UnSettleChartItemVM

@end

@interface UnSettleVM ()

@property (strong, nonatomic) NSMutableArray<UnSettleItemVM *> *itemList;
@property (strong, nonatomic) NSMutableArray<UnSettleChartItemVM *> *chartItemList;

@end

@implementation UnSettleVM

- (NSMutableArray<UnSettleItemVM *> *)itemList {
	if (_itemList == nil) {
		_itemList = [NSMutableArray array];
	}
	return _itemList;
}

- (NSMutableArray<UnSettleChartItemVM *> *)chartItemList {
	if (_chartItemList == nil) {
		_chartItemList = [NSMutableArray array];
	}
	return _chartItemList;
}

- (NSString *)num {
	if (_num == nil) {
		_num = @"-";
	}
	return _num;
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


- (void)listRequestWithComplete:(void (^)(BOOL, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"orgId"];
	//[parameters setObject:@"402883c0434365a7014346c7cc6f5e65" forKey:@"orgId"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"deptId"];
	}
	if (self.selectedDate == nil || [self.selectedDate isEqualToString:@""]) {
		if (failure) {
			failure();
		}
		return;
	} else {
		[parameters setObject:self.selectedDate forKey:@"billingDate"];
	}
	[parameters setObject:self.code forKey:@"code"];
	[parameters setObject:[NSString stringWithFormat:@"%zd", self.currentPage] forKey:@"index"];
	[parameters setObject:@20 forKey:@"size"];

	[self.sessionManager POST:@"getStoreDetail4List.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *unSettleList = response[@"data"];
			if (self.currentPage == 1) {
				[self.itemList removeAllObjects];
			}
			for (NSDictionary *unSettle in unSettleList) {
				UnSettleItemVM *item = [[UnSettleItemVM alloc] init];
				item.name = unSettle[@"memberName"] == [NSNull null] ? @"" : unSettle[@"memberName"];
				item.carNum = unSettle[@"licenNum"] == [NSNull null] ? @"" : unSettle[@"licenNum"];
				item.phone = unSettle[@"telNumber"] == [NSNull null] ? @"" : unSettle[@"telNumber"];
				[self.itemList addObject:item];
			}
			self.listDataSource = [self.itemList copy];
			if (unSettleList.count > 0) {
				self.currentPage += 1;
			}
			if (complete) {
				complete(YES, nil);
			}
		} else {
			if (self.currentPage == 1) {
				[self.itemList removeAllObjects];
				self.listDataSource = nil;
			}
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

- (void)chartRequestWithComplete:(void (^)(BOOL, NSString *, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"orgId"];
	//[parameters setObject:@"402883c0434365a7014346c7cc6f5e65" forKey:@"orgId"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"deptId"];
	}
	[parameters setObject:self.code forKey:@"code"];
	[parameters setObject:self.startDate forKey:@"startDate"];
	[parameters setObject:self.endDate forKey:@"endDate"];
	//	[parameters setObject:@"2015-05-01" forKey:@"startDate"];
	//	[parameters setObject:@"2015-05-07" forKey:@"endDate"];

	[self.sessionManager POST:@"getStoreDetail.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *chartData = response[@"data"];
			[self clearList];
			[self.chartItemList removeAllObjects];
			for (NSDictionary *chart in chartData) {
				UnSettleChartItemVM *item = [[UnSettleChartItemVM alloc] init];
				item.date = chart[@"billingDate"];
				item.count = [chart[@"number"] integerValue];
				[self.chartItemList addObject:item];
			}
			self.chartDataSource = [self.chartItemList copy];
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
}

- (NSString *)jsStr {
	NSString *jsStr = @"var stringList = \"";
	for (NSInteger i = 0; i < self.chartDataSource.count; ++i) {
		UnSettleChartItemVM *item = self.chartDataSource[i];
		jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"%ld,", item.count]];
	}
	jsStr = [jsStr substringToIndex:jsStr.length-1];
	jsStr = [jsStr stringByAppendingString:@"\";"];
	NSArray<NSString *> *dateFragment = [self.startDate componentsSeparatedByString:@"-"];
	jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"setAreaPeriodData(stringList, null, %zd, %zd, %zd,'未交车台次', '台', 0);", [dateFragment[0] integerValue], [dateFragment[1] integerValue], [dateFragment[2] integerValue]]];
	return jsStr;
}

- (void)clearList {
	self.num = nil;
	[self.itemList removeAllObjects];
	self.listDataSource = nil;
}

@end
