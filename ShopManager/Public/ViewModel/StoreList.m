//
//  StoreList.m
//  ShopManager
//
//  Created by 张旭 on 28/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "StoreList.h"
#import "HttpClient.h"

@implementation StoreItem

@end

@interface StoreList ()

@property (strong, nonatomic) NSMutableArray<StoreItem *> *itemList;

@end

@implementation StoreList

static StoreList *sharedInstance = nil;

+ (instancetype)sharedList {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[StoreList alloc] init];
	});
	return sharedInstance;
}

- (instancetype)init {
	self = [super init];
	return self;
}

- (NSMutableArray<StoreItem *> *)itemList {
	if (_itemList == nil) {
		_itemList = [NSMutableArray array];
	}
	return _itemList;
}

- (void)requestWithComplete:(void (^)(BOOL))complete failure:(void (^)())failure {
	[[HttpClient sharedHttpClient] getStoreDataWithCompletion:^(BOOL success, NSArray *data) {
		if (success) {
			StoreItem *companyItem = [[StoreItem alloc] init];
			companyItem.name = [User sharedUser].companyName;
			companyItem.idStr = @"";
			//[self.itemList addObject:companyItem];
			self.selectedName = companyItem.name;
			self.selectedId = companyItem.idStr;
			for (Store *item in data) {
				StoreItem *storeItem = [[StoreItem alloc] init];
				storeItem.name = item.storeName;
				storeItem.idStr = item.storeID;
				[self.itemList addObject:storeItem];
			}
			self.dataSource = [@[companyItem] arrayByAddingObjectsFromArray:self.itemList];
			self.dataSource2 = [self.itemList copy];
			if (complete) {
				complete(YES);
			}
		} else {
			if (complete) {
				complete(NO);
			}
		}
	} failure:^{
		if (failure) {
			failure();
		}
	}];
}

@end
