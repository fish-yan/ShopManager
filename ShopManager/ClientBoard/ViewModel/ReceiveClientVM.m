//
//  ReceiveClientVM.m
//  ShopManager
//
//  Created by 张旭 on 04/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "ReceiveClientVM.h"

@implementation ReceiveClientItemVM

@end

@implementation ReceiveClientChartItemVM

@end

@interface ReceiveClientVM ()

@property (strong, nonatomic) NSMutableArray<ReceiveClientItemVM *> *itemList;
@property (strong, nonatomic) NSMutableArray<ReceiveClientChartItemVM *> *chartItemList;

@end

@implementation ReceiveClientVM

- (NSMutableArray<ReceiveClientItemVM *> *)itemList {
	if (_itemList == nil) {
		_itemList = [NSMutableArray array];
	}
	return _itemList;
}

- (NSMutableArray<ReceiveClientChartItemVM *> *)chartItemList {
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
		if ([self.code isEqualToString:@"CRM_DESK_STORE_DDKHL"]) {
			[parameters setObject:self.selectedDate forKey:@"createDate"];
		} else {
			[parameters setObject:self.selectedDate forKey:@"adoptDate"];
		}
	}
	[parameters setObject:self.code forKey:@"code"];
	[parameters setObject:[NSString stringWithFormat:@"%zd", self.currentPage] forKey:@"index"];
	[parameters setObject:@20 forKey:@"size"];
	NSString *url = @"";
	if (self.type == 0) {
		url = @"getCustomDetail4Service.do";
	} else {
		url = @"getCustomDetail4Adopt.do";
	}
	[self.sessionManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *clientList = response[@"data"];
			if (self.currentPage == 1) {
				[self.itemList removeAllObjects];
			}
			for (NSDictionary *client in clientList) {
				ReceiveClientItemVM *item = [[ReceiveClientItemVM alloc] init];
				if (self.type == 0) {
					item.name = client[@"membername"] == [NSNull null] ? @"" : client[@"membername"];
					item.carNum = client[@"licennum"] == [NSNull null] ? @"" : client[@"licennum"];
					item.phone = client[@"telnumber"] == [NSNull null] ? @"" : client[@"telnumber"];
					item.clientManager = client[@"clientmanager"] == [NSNull null] ? @"" : client[@"clientmanager"];
					item.birthday = client[@"birthday"] == [NSNull null] ? @"" : client[@"birthday"];
				} else {
					item.name = client[@"LEAGUERNAME"] == [NSNull null] ? @"" : client[@"LEAGUERNAME"];
					item.carNum = client[@"CARNUMBER"] == [NSNull null] ? @"" : client[@"CARNUMBER"];
					item.phone = client[@"MOBILE"] == [NSNull null] ? @"" : client[@"MOBILE"];
					item.clientManager = client[@"CLIENTMANAGER"] == [NSNull null] ? @"" : client[@"CLIENTMANAGER"];
					item.birthday = client[@"telnumber"] == [NSNull null] ? @"" : client[@"telnumber"];
				}

				[self.itemList addObject:item];
			}
			self.listDataSource = [self.itemList copy];
			if (clientList.count > 0) {
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

	[self.sessionManager POST:@"getCustomDetail.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *chartData = response[@"data"];
			[self clearList];
			[self.chartItemList removeAllObjects];
			for (NSDictionary *chart in chartData) {
				ReceiveClientChartItemVM *item = [[ReceiveClientChartItemVM alloc] init];
				if (self.type == 0) {
					item.date = chart[@"createDate"];
					item.count = [chart[@"num"] integerValue];
				} else {
					item.date = chart[@"ADOPTDATE"];
					item.count = [chart[@"NUM"] integerValue];
				}
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
		ReceiveClientChartItemVM *item = self.chartDataSource[i];
		jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"%ld,", item.count]];
	}
	jsStr = [jsStr substringToIndex:jsStr.length-1];
	jsStr = [jsStr stringByAppendingString:@"\";"];
	NSArray<NSString *> *dateFragment = [self.startDate componentsSeparatedByString:@"-"];
	jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"setAreaPeriodData(stringList, null, %zd, %zd, %zd,'领养客户', '人', 0);", [dateFragment[0] integerValue], [dateFragment[1] integerValue], [dateFragment[2] integerValue]]];
	return jsStr;
}

- (void)clearList {
	[self.itemList removeAllObjects];
	self.listDataSource = nil;
}

@end
