//
//  IndexStoreBoardVM.m
//  ShopManager
//
//  Created by 张旭 on 25/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "IndexStoreBoardVM.h"
#import "HttpClient.h"
#import "StoreList.h"


@implementation IndexStoreBoardVM

- (NSString *)washCarNum {
	if (_washCarNum == nil) {
		_washCarNum = @"-";
	}
	return _washCarNum;
}

- (NSString *)washCarLastNum {
	if (_washCarLastNum == nil) {
		_washCarLastNum = @"-";
	}
	return _washCarLastNum;
}

- (NSString *)comeInNum {
	if (_comeInNum == nil) {
		_comeInNum = @"-";
	}
	return _comeInNum;
}

- (NSString *)comeInLastNum {
	if (_comeInLastNum == nil) {
		_comeInLastNum = @"-";
	}
	return _comeInLastNum;
}

- (NSString *)sectorNum {
	if (_sectorNum == nil) {
		_sectorNum = @"-";
	}
	return _sectorNum;
}

- (NSString *)sectorLastNum {
	if (_sectorLastNum == nil) {
		_sectorLastNum = @"-";
	}
	return _sectorLastNum;
}

- (NSString *)unSettleNum {
	if (_unSettleNum == nil) {
		_unSettleNum = @"-";
	}
	return _unSettleNum;
}

- (NSString *)unSettleLastNum {
	if (_unSettleLastNum == nil) {
		_unSettleLastNum = @"-";
	}
	return _unSettleLastNum;
}

- (NSString *)receivableNum {
	if (_receivableNum == nil) {
		_receivableNum = @"-";
	}
	return _receivableNum;
}

- (NSString *)receivableLastNum {
	if (_receivableLastNum == nil) {
		_receivableLastNum = @"-";
	}
	return _receivableLastNum;
}

- (NSString *)profitNum {
	if (_profitNum == nil) {
		_profitNum = @"-";
	}
	return _profitNum;
}

- (NSString *)profitLastNum {
	if (_profitLastNum == nil) {
		_profitLastNum = @"-";
	}
	return _profitLastNum;
}

- (void)requestWithComplete:(void (^)(BOOL))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"orgId"];
	if ([StoreList sharedList].selectedId != nil && ![[StoreList sharedList].selectedId isEqualToString:@""]) {
		[parameters setObject:[User sharedUser].storeID forKey:@"deptId"];
	}

	[self.sessionManager POST:@"getStoreCount.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *storeCountList = response[@"data"];
			for (NSDictionary *storeCount in storeCountList) {
				if ([storeCount[@"name"] isEqualToString:@"洗车台数"]) {
					self.washCarNum = storeCount[@"thisMonthVal"];
					self.washCarLastNum = storeCount[@"lastMonthVal"];
					self.washCarCode = storeCount[@"code"];
					self.washCarIsUp = [storeCount[@"isUp"] integerValue];
				} else if ([storeCount[@"name"] isEqualToString:@"进场台数"]) {
					self.comeInNum = storeCount[@"thisMonthVal"];
					self.comeInLastNum = storeCount[@"lastMonthVal"];
					self.comeInCode = storeCount[@"code"];
					self.comeInIsUp = [storeCount[@"isUp"] integerValue];
				} else if ([storeCount[@"name"] isEqualToString:@"部门转化率"]) {
					self.sectorNum = storeCount[@"thisMonthVal"];
					self.sectorLastNum = storeCount[@"lastMonthVal"];
					self.sectorCode = storeCount[@"code"];
					self.sectorIsUp = [storeCount[@"isUp"] integerValue];
				} else if ([storeCount[@"name"] isEqualToString:@"未交车台数"]) {
					self.unSettleNum = storeCount[@"thisMonthVal"];
					self.unSettleLastNum = storeCount[@"lastMonthVal"];
					self.unSettleCode = storeCount[@"code"];
					self.unSettleIsUp = [storeCount[@"isUp"] integerValue];
				} else if ([storeCount[@"name"] isEqualToString:@"应收账款额"]) {
					self.receivableNum = storeCount[@"thisMonthVal"];
					self.receivableLastNum = storeCount[@"lastMonthVal"];
					self.receivableCode = storeCount[@"code"];
					self.receivableIsUp = [storeCount[@"isUp"] integerValue];
				} else if ([storeCount[@"name"] isEqualToString:@"均单毛利"]) {
					self.profitNum = storeCount[@"thisMonthVal"];
					self.profitLastNum = storeCount[@"lastMonthVal"];
					self.profitCode = storeCount[@"code"];
					self.profitIsUp = [storeCount[@"isUp"] integerValue];
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
