//
//  ClientLevelVM.m
//  ShopManager
//
//  Created by 张旭 on 04/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "ClientLevelVM.h"

@implementation ClientLevelItemVM

@end

@implementation ClientLevelChartItemVM

@end

@interface ClientLevelVM ()

@property (strong, nonatomic) NSMutableArray<ClientLevelItemVM *> *itemList;
@property (strong, nonatomic) NSMutableArray<ClientLevelChartItemVM *> *chartItemList;

@end

@implementation ClientLevelVM

- (NSMutableArray<ClientLevelItemVM *> *)itemList {
	if (_itemList == nil) {
		_itemList = [NSMutableArray array];
	}
	return _itemList;
}

- (NSMutableArray<ClientLevelChartItemVM *> *)chartItemList {
	if (_chartItemList == nil) {
		_chartItemList = [NSMutableArray array];
	}
	return _chartItemList;
}

- (void)listRequestWithComplete:(void (^)(BOOL, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"orgId"];
	//[parameters setObject:@"402883c0434365a7014346c7cc6f5e65" forKey:@"orgId"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"deptId"];
	}
	[parameters setObject:self.code forKey:@"code"];
	[parameters setObject:[NSNumber numberWithFloat:self.selectedStar] forKey:@"star"];
	[parameters setObject:[NSString stringWithFormat:@"%zd", self.currentPage] forKey:@"index"];
	[parameters setObject:@20 forKey:@"size"];

	[self.sessionManager POST:@"getCustomDetail4Star.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *clientList = response[@"data"];
			if (self.currentPage == 1) {
				[self.itemList removeAllObjects];
			}
			for (NSDictionary *client in clientList) {
				ClientLevelItemVM *item = [[ClientLevelItemVM alloc] init];
				item.name = client[@"leaguername"] == [NSNull null] ? @"" : client[@"leaguername"];
				item.carNum = client[@"carnumber"] == [NSNull null] ? @"" : client[@"carnumber"];
				item.phone = client[@"mobile"] == [NSNull null] ? @"" : client[@"mobile"];
				item.adopter = client[@"clientmanager"] == [NSNull null] ? @"" : client[@"clientmanager"];
				item.xc = [client[@"xc"] doubleValue];
				item.mr = [client[@"mr"] doubleValue];
				item.jx = [client[@"jx"] doubleValue];
				item.bx = [client[@"bx"] doubleValue];
				item.lt = [client[@"lt"] doubleValue];
				item.bp = [client[@"bp"] doubleValue];
				item.yp = [client[@"yp"] doubleValue];
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
				ClientLevelChartItemVM *item = [[ClientLevelChartItemVM alloc] init];
				item.star = [chart[@"star"] doubleValue];
				item.count = [chart[@"num"] integerValue];
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
	NSString *jsStr = @"var starList = [];";
	for (NSInteger i = 0; i < self.chartDataSource.count; ++i) {
		ClientLevelChartItemVM *item = self.chartDataSource[i];
		jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"starList.push(new Item(%f, %zd));", item.star, item.count]];
	}
	jsStr = [jsStr stringByAppendingString:[NSString stringWithFormat:@"setStarData(starList);"]];
	return jsStr;
}

- (void)clearList {
	self.selectedStar = 0;
	[self.itemList removeAllObjects];
	self.listDataSource = nil;
}

@end
