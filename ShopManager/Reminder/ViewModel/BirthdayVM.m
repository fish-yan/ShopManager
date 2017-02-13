//
//  BirthdayVM.m
//  ShopManager
//
//  Created by 张旭 on 25/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "BirthdayVM.h"
#import "HttpClient.h"

@implementation BirthdayItemVM

@end

@interface BirthdayVM ()

@property (strong, nonatomic) NSMutableArray<BirthdayItemVM *> *itemList;

@end

@implementation BirthdayVM

- (NSMutableArray<BirthdayItemVM *> *)itemList {
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
			NSArray *birthdayList = response[@"data"];
			if (self.currentPage == 1) {
				[self.itemList removeAllObjects];
			}
			for (NSDictionary *birthday in birthdayList) {
				BirthdayItemVM *item = [[BirthdayItemVM alloc] init];
				item.name = birthday[@"LEAGUERNAME"] == [NSNull null] ? @"" : birthday[@"LEAGUERNAME"];
				item.birthday = birthday[@"THISBIRTHDAY"] == [NSNull null] ? @"" : birthday[@"THISBIRTHDAY"];
				item.phone = birthday[@"MOBILE"] == [NSNull null] ? @"" : birthday[@"MOBILE"];
				item.number = birthday[@"LEAGUERNUM"] == [NSNull null] ? @"" : birthday[@"LEAGUERNUM"];
				item.adopter = birthday[@"CLIENTMANAGER"] == [NSNull null] ? @"" : birthday[@"CLIENTMANAGER"];
				[self.itemList addObject:item];
			}
			self.dataSource = [self.itemList copy];
			if (birthdayList.count > 0) {
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
