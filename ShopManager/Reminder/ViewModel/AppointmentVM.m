//
//  AppointmentVM.m
//  ShopManager
//
//  Created by 张旭 on 26/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "AppointmentVM.h"

@implementation AppointmentItemVM

@end

@interface AppointmentVM ()

@property (strong, nonatomic) NSMutableArray<AppointmentItemVM *> *itemList;

@end

@implementation AppointmentVM

- (NSMutableArray<AppointmentItemVM *> *)itemList {
	if (_itemList == nil) {
		_itemList = [NSMutableArray array];
	}
	return _itemList;
}

- (void)requestWithComplete:(void (^)(BOOL, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"orgId"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"deptId"];
	}
	[parameters setObject:self.code forKey:@"queryType"];
	[parameters setObject:[NSNumber numberWithInteger:self.currentPage] forKey:@"index"];
	[parameters setObject:@20 forKey:@"size"];

	[self.sessionManager POST:@"getWarnDetails.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *approveList = response[@"data"];
			if (self.currentPage == 1) {
				[self.itemList removeAllObjects];
			}
			for (NSDictionary *approve in approveList) {
				AppointmentItemVM *item = [[AppointmentItemVM alloc] init];
				item.carNum = approve[@"CARNUM"] == [NSNull null] ? @"" : approve[@"CARNUM"];
				item.name = approve[@"SERVICEUSER"] == [NSNull null] ? @"" : approve[@"SERVICEUSER"];
				item.phone = approve[@"MOBILE"] == [NSNull null] ? @"" : approve[@"MOBILE"];
				item.store = approve[@"SERVICESTORE"] == [NSNull null] ? @"" : approve[@"SERVICESTORE"];
				item.time = approve[@"THISSERVICETIME"] == [NSNull null] ? @"" : approve[@"THISSERVICETIME"];
				item.adopter = approve[@"CLIENTMANAGER"] == [NSNull null] ? @"" : approve[@"CLIENTMANAGER"];
				[self.itemList addObject:item];
			}
			self.dataSource = [self.itemList copy];
			if (approveList.count > 0) {
				self.currentPage += 1;
			}
			if (complete) {
				complete(YES, nil);
			}
		} else {
			if (self.currentPage == 1) {
				[self.itemList removeAllObjects];
				self.dataSource = nil;
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

@end
