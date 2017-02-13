//
//  SaleAnalyseDetailVM.m
//  ShopManager
//
//  Created by 张旭 on 09/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "SaleAnalyseDetailVM.h"

@implementation SaleAnalyseDetailItemVM

@end

@interface SaleAnalyseDetailVM ()

@property (strong, nonatomic) NSMutableArray<SaleAnalyseDetailItemVM *> *itemList;

@end

@implementation SaleAnalyseDetailVM

- (NSMutableArray<SaleAnalyseDetailItemVM *> *)itemList {
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
	if (self.type == 0) {
		[parameters setObject:@"one" forKey:@"type"];
	} else if (self.type == 1) {
		[parameters setObject:@"two" forKey:@"type"];
	}
	if (self.detailType == 0) {
		[parameters setObject:@2 forKey:@"itemstyle"];
	} else if (self.detailType == 1) {
		[parameters setObject:@0 forKey:@"itemstyle"];
	} else if (self.detailType == 2) {
		[parameters setObject:@1 forKey:@"itemstyle"];
	}

	[self.sessionManager POST:@"getSalesProductReport.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *listData = response[@"data"];
			[self.itemList removeAllObjects];
			self.totalMoney = 0;
			for (NSDictionary *dict in listData) {
				SaleAnalyseDetailItemVM *item = [[SaleAnalyseDetailItemVM alloc] init];
				if (self.type == 0) {
					item.name = dict[@"costobjectname"] == [NSNull null] ? @"" : dict[@"costobjectname"];
				} else if (self.type == 1) {
					item.name = dict[@"deptname"] == [NSNull null] ? @"" : dict[@"deptname"];
				}
				item.count = [dict[@"taxsaletotal"] doubleValue];
				self.totalMoney += item.count;
				[self.itemList addObject:item];
			}
			for (SaleAnalyseDetailItemVM *item in self.itemList) {
				if (self.totalMoney == 0) {
					item.percent = 0;
				} else {
					item.percent = item.count/self.totalMoney*100;
				}
			}
			self.listDataSource = [self.itemList copy];
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

- (void)listRequest2WithCompletion:(void (^)(BOOL, NSString *, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"companyID"];
	//[parameters setObject:@"402883c0434365a7014346c7cc6f5e65" forKey:@"companyID"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"storeId"];
	}
	[parameters setObject:self.startDate forKey:@"beginTime"];
	[parameters setObject:self.endDate forKey:@"endTime"];
	if (self.type == 0) {
		[parameters setObject:self.keyWord forKey:@"costobjectname"];
	} else if (self.type == 1) {
		[parameters setObject:self.keyWord forKey:@"deptname"];
	}
	[self.sessionManager POST:@"getSalesProductReportTwo.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *listData = response[@"data"];
			[self.itemList removeAllObjects];
			self.totalMoney = 0;
			for (NSDictionary *dict in listData) {
				SaleAnalyseDetailItemVM *item = [[SaleAnalyseDetailItemVM alloc] init];
				item.name = dict[@"itemstyle"];
				item.count = [dict[@"taxsaletotal"] doubleValue];
				self.totalMoney += item.count;
				[self.itemList addObject:item];
			}
			for (SaleAnalyseDetailItemVM *item in self.itemList) {
				if (self.totalMoney == 0) {
					item.percent = 0;
				} else {
					item.percent = item.count/self.totalMoney*100;
				}
			}
			self.listDataSource = [self.itemList copy];
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
	NSString *jsStr = @"var starList = [];";
	for (SaleAnalyseDetailItemVM *item in self.listDataSource) {
		jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"starList.push(new PieItem('%@', %.2f));", item.name, item.percent]];
	}
	jsStr = [jsStr stringByAppendingString:@"setPieData(starList, null, '销售占比', '%');"];
	return jsStr;
}

- (void)clearList {
	[self.itemList removeAllObjects];
	self.listDataSource = nil;
}

@end
