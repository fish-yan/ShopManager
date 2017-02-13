//
//  IndexClientBoardVM.m
//  ShopManager
//
//  Created by 张旭 on 25/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "IndexClientBoardVM.h"
#import "HttpClient.h"
#import "StoreList.h"

@implementation IndexClientBoardVM

- (NSString *)serviceClientNum {
	if (_serviceClientNum == nil) {
		_serviceClientNum = @"-";
	}
	return _serviceClientNum;
}

- (NSString *)newlyClientNum {
	if (_newlyClientNum == nil) {
		_newlyClientNum = @"-";
	}
	return _newlyClientNum;
}

- (NSString *)preLoseClientNum {
	if (_preLoseClientNum == nil) {
		_preLoseClientNum = @"-";
	}
	return _preLoseClientNum;
}

- (NSString *)loseClientNum {
	if (_loseClientNum == nil) {
		_loseClientNum = @"-";
	}
	return _loseClientNum;
}

- (NSString *)starClientNum {
	if (_starClientNum == nil) {
		_starClientNum = @"-";
	}
	return _starClientNum;
}

- (NSString *)adoptClientNum {
	if (_adoptClientNum == nil) {
		_adoptClientNum = @"-";
	}
	return _adoptClientNum;
}

- (void)clearData {
	
}

- (void)requestWithComplete:(void (^)(BOOL))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"orgId"];
	if ([StoreList sharedList].selectedId != nil && ![[StoreList sharedList].selectedId isEqualToString:@""]) {
		[parameters setObject:[User sharedUser].storeID forKey:@"deptId"];
	}

	[self.sessionManager POST:@"getCustomCount.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *clientCountList = response[@"data"];
			for (NSDictionary *clientCount in clientCountList) {
				if ([clientCount[@"name"] isEqualToString:@"服务客户量"]) {
					self.serviceClientNum = clientCount[@"thisMonthVal"];
					self.serviceClientCode = clientCount[@"code"];
					self.serviceClientIsUp = [clientCount[@"isUp"] integerValue];
				} else if ([clientCount[@"name"] isEqualToString:@"新增客户量"]) {
					self.newlyClientNum = clientCount[@"thisMonthVal"];
					self.newlyClientCode = clientCount[@"code"];
					self.newlyClientIsUp = [clientCount[@"isUp"] integerValue];
				} else if ([clientCount[@"name"] isEqualToString:@"客户准流失量"]) {
					self.preLoseClientNum = clientCount[@"thisMonthVal"];
					self.preLoseClientCode = clientCount[@"code"];
					self.preLoseClientIsUp = [clientCount[@"isUp"] integerValue];
				} else if ([clientCount[@"name"] isEqualToString:@"客户流失量"]) {
					self.loseClientNum = clientCount[@"thisMonthVal"];
					self.loseClientCode = clientCount[@"code"];
					self.loseClientIsUp = [clientCount[@"isUp"] integerValue];
				} else if ([clientCount[@"name"] isEqualToString:@"星级客户数"]) {
					self.starClientNum = clientCount[@"thisMonthVal"];
					self.starClientCode = clientCount[@"code"];
					self.starClientIsUp = [clientCount[@"isUp"] integerValue];
				} else if ([clientCount[@"name"] isEqualToString:@"领养客户量"]) {
					self.adoptClientNum = clientCount[@"thisMonthVal"];
					self.adoptClientCode = clientCount[@"code"];
					self.adoptClientIsUp = [clientCount[@"isUp"] integerValue];
				}
			}
			if (complete) {
				complete(YES);
			}
		} else {
			if (complete) {
				complete(NO);
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
