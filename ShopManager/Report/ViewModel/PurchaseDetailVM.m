//
//  PurchaseDetailVM.m
//  ShopManager
//
//  Created by 张旭 on 17/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "PurchaseDetailVM.h"

@implementation PurchaseDetailItemVM

@end

@interface PurchaseDetailVM ()

@property (strong, nonatomic) NSMutableArray<PurchaseDetailItemVM *> *itemList;

@end

@implementation PurchaseDetailVM

- (NSMutableArray<PurchaseDetailItemVM *> *)itemList {
	if (_itemList == nil) {
		_itemList = [NSMutableArray array];
	}
	return _itemList;
}

- (NSString *)showTime {
	return [NSString stringWithFormat:@"%@~%@", self.startDate, self.endDate];
}

- (NSString *)startDate {
	if (_startDate == nil) {
		NSDate *date = [NSDate date];
		_startDate = [NSString stringWithFormat:@"%zd-%02zd-%02zd", date.year, date.month, 1];
	}
	return _startDate;
}

- (NSString *)endDate {
	if (_endDate == nil) {
		NSDate *date = [NSDate date];
		NSInteger days = [date daysInMonth];
		_endDate = [NSString stringWithFormat:@"%zd-%02zd-%02zd", date.year, date.month, days];
	}
	return _endDate;
}

- (void)listRequestWithCompletion:(void (^)(BOOL, NSString *))complete failure:(void (^)())failure {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[User sharedUser].companyID forKey:@"companyID"];
	//[parameters setObject:@"402883c0434365a7014346c7cc6f5e65" forKey:@"companyID"];
	if (self.storeId != nil && ![self.storeId isEqualToString:@""]) {
		[parameters setObject:self.storeId forKey:@"storeId"];
	}
	[parameters setObject:self.startDate forKey:@"beginTime"];
	[parameters setObject:self.endDate forKey:@"endTime"];
	[parameters setObject:self.supplierId forKey:@"supplierId"];
	if (self.keyVal != nil && ![self.keyVal isEqualToString:@""]) {
		[parameters setObject:self.keyVal forKey:@"keyVal"];
	}
	if (self.settleType != nil && ![self.settleType isEqualToString:@""]) {
		[parameters setObject:self.settleType forKey:@"saleType"];
	}
	if (self.orderType != nil && ![self.orderType isEqualToString:@""]) {
		[parameters setObject:self.orderType forKey:@"orderName"];
	}
	if (self.storageName != nil && ![self.storageName isEqualToString:@""]) {
		[parameters setObject:self.storageName forKey:@"warehouseName"];
	}
	[parameters setObject:[NSNumber numberWithInteger:self.currentPage] forKey:@"index"];
	[parameters setObject:@20 forKey:@"size"];
	[self.sessionManager POST:@"getInStore4Supplier.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@", responseObject);
		NSDictionary *response = responseObject;
		if ([response[@"type"] integerValue] == 1){
			NSArray *listData = response[@"data"];
			if (self.currentPage == 1) {
				[self.itemList removeAllObjects];
			}
			for (NSDictionary *dict in listData) {
				PurchaseDetailItemVM *item = [[PurchaseDetailItemVM alloc] init];
				item.name = dict[@"productName"];
				item.price = [dict[@"taxPrice"] doubleValue];
				item.totalPrice = [dict[@"TaxTotalPay"] doubleValue];
				item.num = [dict[@"packNum"] integerValue];
				item.settleType = dict[@"saleType"];
				item.orderType = dict[@"orderName"];
				item.time = dict[@"yck_createDates"];
				[self.itemList addObject:item];
			}
			self.listDataSource = [self.itemList copy];
			if (listData.count > 0) {
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

@end
