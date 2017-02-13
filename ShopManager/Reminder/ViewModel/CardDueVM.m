//
//  CardDueVM.m
//  ShopManager
//
//  Created by 张旭 on 26/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "CardDueVM.h"

@implementation CardDueItemVM

@end

@interface CardDueVM ()

@property (strong, nonatomic) NSMutableArray<CardDueItemVM *> *itemList;

@end

@implementation CardDueVM

- (NSMutableArray<CardDueItemVM *> *)itemList {
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
			NSArray *cardDueList = response[@"data"];
			if (self.currentPage == 1) {
				[self.itemList removeAllObjects];
			}
			for (NSDictionary *cardDue in cardDueList) {
				CardDueItemVM *item = [[CardDueItemVM alloc] init];
				item.carNum = cardDue[@"CICARNUMBER"] == [NSNull null] ? @"" : cardDue[@"CICARNUMBER"];
				item.name = cardDue[@"LEAGUERNAME"] == [NSNull null] ? @"" : cardDue[@"LEAGUERNAME"];
				item.phone = cardDue[@"PHONE"] == [NSNull null] ? @"" : cardDue[@"PHONE"];
				item.startTime = cardDue[@"ACTIVEDATE"] == [NSNull null] ? @"" : cardDue[@"ACTIVEDATE"];
				item.dueTime = cardDue[@"CLOSEDATE"] == [NSNull null] ? @"" : cardDue[@"CLOSEDATE"];
				item.storeName = cardDue[@"STORESNAME"] == [NSNull null] ? @"" : cardDue[@"STORESNAME"];
				item.cardName = cardDue[@"CARDCLASSNAME"] == [NSNull null] ? @"" : cardDue[@"CARDCLASSNAME"];
				[self.itemList addObject:item];
			}
			self.dataSource = [self.itemList copy];
			if (cardDueList.count > 0) {
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
