//
//  ReminderVM.m
//  ShopManager
//
//  Created by 张旭 on 24/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "IndexReminderVM.h"
#import "HttpClient.h"
#import "StoreList.h"


@implementation IndexReminderVM

- (NSString *)birthdayNum {
	if (_birthdayNum == nil) {
		_birthdayNum = @"-";
	}
	return _birthdayNum;
}

- (NSString *)appointmentNum {
	if (_appointmentNum == nil) {
		_appointmentNum = @"-";
	}
	return _appointmentNum;
}

- (NSString *)serviceDueNum {
	if (_serviceDueNum == nil) {
		_serviceDueNum = @"-";
	}
	return _serviceDueNum;
}

- (NSString *)cardDueNum {
	if (_cardDueNum == nil) {
		_cardDueNum = @"-";
	}
	return _cardDueNum;
}

- (void)requestWithComplete:(void (^)(BOOL))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"orgId"];
	if ([StoreList sharedList].selectedId != nil && ![[StoreList sharedList].selectedId isEqualToString:@""]) {
		[parameters setObject:[User sharedUser].storeID forKey:@"deptId"];
	}

	[self.sessionManager POST:@"getWarnCount.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1) {
			NSArray *reminderList = response[@"data"];
			for (NSDictionary *reminder in reminderList) {
				if ([reminder[@"name"] isEqualToString:@"生日提醒"]) {
					self.birthdayNum = reminder[@"val"];
					self.birthdayCode = reminder[@"queryType"];
				} else if ([reminder[@"name"] isEqualToString:@"预约提醒"]) {
					self.appointmentNum = reminder[@"val"];
					self.appointmentCode = reminder[@"queryType"];
				} else if ([reminder[@"name"] isEqualToString:@"服务到期"]) {
					self.serviceDueNum = reminder[@"val"];
					self.serviceDueCode = reminder[@"queryType"];
				} else if ([reminder[@"name"] isEqualToString:@"卡到期"]) {
					self.cardDueNum = reminder[@"val"];
					self.cardDueCode = reminder[@"queryType"];
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
