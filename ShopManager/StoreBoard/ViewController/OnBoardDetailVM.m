//
//  OnBoardDetailVM.m
//  ShopManager
//
//  Created by 张旭 on 03/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "OnBoardDetailVM.h"

@implementation OnBoardDetailItemVM

- (NSString *)name {
	if (_name == nil) {
		_name = @"";
	}
	return [NSString stringWithFormat:@"客户姓名：%@", _name];
}

- (NSString *)carNum {
	if (_carNum == nil) {
		_carNum = @"";
	}
	return [NSString stringWithFormat:@"车牌号码：%@", _carNum];
}

- (NSString *)phone {
	if (_phone == nil) {
		_phone = @"";
	}
	return [NSString stringWithFormat:@"联系方式：%@", _phone];
}

@end

@interface OnBoardDetailVM ()

@property (strong, nonatomic) NSMutableArray<OnBoardDetailItemVM *> *itemList;

@end

@implementation OnBoardDetailVM

- (NSMutableArray<OnBoardDetailItemVM *> *)itemList {
	if (_itemList == nil) {
		_itemList = [NSMutableArray array];
	}
	return _itemList;
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
	[parameters setObject:self.type forKey:@"type"];
	[parameters setObject:[NSString stringWithFormat:@"%zd", self.currentPage] forKey:@"index"];
	[parameters setObject:@20 forKey:@"size"];

	[self.sessionManager POST:@"getStoreDetail4List.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *onBoardList = response[@"data"];
			if (self.currentPage == 1) {
				[self.itemList removeAllObjects];
			}
			for (NSDictionary *onBoard in onBoardList) {
				OnBoardDetailItemVM *item = [[OnBoardDetailItemVM alloc] init];
				item.name = onBoard[@"memberName"] == [NSNull null] ? @"" : onBoard[@"memberName"];
				item.carNum = onBoard[@"licenNum"] == [NSNull null] ? @"" : onBoard[@"licenNum"];
				item.phone = onBoard[@"telnumber"] == [NSNull null] ? @"" : onBoard[@"telnumber"];
				[self.itemList addObject:item];
			}
			self.dataSource = [self.itemList copy];
			if (onBoardList.count > 0) {
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
