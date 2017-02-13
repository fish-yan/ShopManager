//
//  NewClientVM.m
//  ShopManager
//
//  Created by 张旭 on 04/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "NewClientVM.h"

@implementation NewClientItemVM

@end

@interface NewClientVM ()

@property (strong, nonatomic) NSMutableArray<NewClientItemVM *> *itemList;

@end

@implementation NewClientVM

- (NSMutableArray<NewClientItemVM *> *)itemList {
	if (_itemList == nil) {
		_itemList = [NSMutableArray array];
	}
	return _itemList;
}

- (void)listRequestWithComplete:(void (^)(BOOL, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"orgId"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"deptId"];
	}
	[parameters setObject:self.code forKey:@"code"];
	[parameters setObject:[NSString stringWithFormat:@"%zd", self.currentPage] forKey:@"index"];
	[parameters setObject:@20 forKey:@"size"];

	[self.sessionManager POST:@"getCustomDetail4List.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *clientList = response[@"data"];
			if (self.currentPage == 1) {
				[self.itemList removeAllObjects];
			}
			for (NSDictionary *client in clientList) {
				NewClientItemVM *item = [[NewClientItemVM alloc] init];
				item.name = client[@"membername"] == [NSNull null] ? @"" : client[@"membername"];
				item.carNum = client[@"licennum"] == [NSNull null] ? @"" : client[@"licennum"];
				item.phone = client[@"telnumber"] == [NSNull null] ? @"" : client[@"telnumber"];
				item.time = client[@"setttime"] == [NSNull null] ? @"" : client[@"setttime"];
				item.storeName = client[@"storename"] == [NSNull null] ? @"" : client[@"storename"];
				[self.itemList addObject:item];
			}
			self.dataSource = [self.itemList copy];
			if (clientList.count > 0) {
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
