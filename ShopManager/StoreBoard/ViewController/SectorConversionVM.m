//
//  SectorConversionVM.m
//  ShopManager
//
//  Created by 张旭 on 01/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "SectorConversionVM.h"

@implementation SectorConversionItemVM

- (NSString *)name {
	if (_name == nil) {
		_name = @"";
	}
	return _name;
}

- (NSString *)rate {
	if (_rate == nil) {
		_rate = @"0";
	}
	return [NSString stringWithFormat:@"%@%%", _rate];
}

@end

@implementation SectorConversionChartItemVM

@end

@interface SectorConversionVM ()

@property (strong, nonatomic) NSMutableArray<SectorConversionItemVM *> *itemList;
@property (strong, nonatomic) NSMutableArray<SectorConversionChartItemVM *> *chartItemList;

@end

@implementation SectorConversionVM

- (NSMutableArray<SectorConversionItemVM *> *)itemList {
	if (_itemList == nil) {
		_itemList = [NSMutableArray array];
	}
	return _itemList;
}

- (NSMutableArray<SectorConversionChartItemVM *> *)chartItemList {
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
	//[parameters setObject:@"402883c0464608900146466b19f90004" forKey:@"orgId"];
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

	[self.sessionManager POST:@"getStoreDetail4List.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *rationList = response[@"data"];
			[self.itemList removeAllObjects];
			for (NSDictionary *ration in rationList) {
				SectorConversionItemVM *item = [[SectorConversionItemVM alloc] init];
				item.name = ration[@"deptname"] == [NSNull null] ? @"" : ration[@"deptname"];
				item.rate = [NSString stringWithFormat:@"%.2f", [ration[@"returnVal"] doubleValue]];
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

- (void)chartRequestWithComplete:(void (^)(BOOL, NSString *, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"orgId"];
	//[parameters setObject:@"402883c0464608900146466b19f90004" forKey:@"orgId"];
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
				SectorConversionChartItemVM *item = [[SectorConversionChartItemVM alloc] init];
				item.date = chart[@"settTime"];
				item.rate = [NSString stringWithFormat:@"%.2f", [chart[@"returnVal"] doubleValue]];
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
		SectorConversionChartItemVM *item = self.chartDataSource[i];
		jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"%@,", item.rate]];
	}
	jsStr = [jsStr substringToIndex:jsStr.length-1];
	jsStr = [jsStr stringByAppendingString:@"\";"];
	NSArray<NSString *> *dateFragment = [self.startDate componentsSeparatedByString:@"-"];
	jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"setAreaPeriodData(stringList, null, %zd, %zd, %zd,'部门转化率', '%%', 2);", [dateFragment[0] integerValue], [dateFragment[1] integerValue], [dateFragment[2] integerValue]]];
	return jsStr;
}

- (void)clearList {
	[self.itemList removeAllObjects];
	self.listDataSource = nil;
}

@end
