//
//  ServiceDueVM.m
//  ShopManager
//
//  Created by 张旭 on 26/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "ServiceDueVM.h"

@implementation ServiceDueItemVM

@end

@interface ServiceDueVM ()

@property (strong, nonatomic) NSMutableArray<ServiceDueItemVM *> *itemList;

@end

@implementation ServiceDueVM

- (NSMutableArray<ServiceDueItemVM *> *)itemList {
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
			NSArray *serviceDueList = response[@"data"];
			if (self.currentPage == 1) {
				[self.itemList removeAllObjects];
			}
			for (NSDictionary *serviceDue in serviceDueList) {
				ServiceDueItemVM *item = [[ServiceDueItemVM alloc] init];
				item.carNum = serviceDue[@"CICARNUMBER"] == [NSNull null] ? @"" : serviceDue[@"CICARNUMBER"];
				item.name = serviceDue[@"LEAGUERNAME"] == [NSNull null] ? @"" : serviceDue[@"LEAGUERNAME"];
				item.phone = serviceDue[@"MOBILE"] == [NSNull null] ? @"" : serviceDue[@"MOBILE"];
				item.nextTime = serviceDue[@"CIMAINTAINTIME"] == [NSNull null] ? @"" : serviceDue[@"CIMAINTAINTIME"];
				item.nextMile = serviceDue[@"CIEVENNUMBER"] == [NSNull null] ? @"" : [NSString stringWithFormat:@"%ld", [serviceDue[@"CIEVENNUMBER"] integerValue]];
				item.storeName = serviceDue[@"STORESNAME"] == [NSNull null] ? @"" : serviceDue[@"STORESNAME"];
				item.adopter = serviceDue[@"CLIENTMANAGER"] == [NSNull null] ? @"" : serviceDue[@"CLIENTMANAGER"];
				[self.itemList addObject:item];
			}
			self.dataSource = [self.itemList copy];
			if (serviceDueList.count > 0) {
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
