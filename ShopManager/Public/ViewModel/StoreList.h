//
//  StoreList.h
//  ShopManager
//
//  Created by 张旭 on 28/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface StoreItem : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *idStr;

@end

@interface StoreList : RequestViewModel

+ (instancetype)sharedList;

- (void)requestWithComplete:(void(^)(BOOL success))complete failure:(void(^)())failure;

@property (strong, nonatomic) NSArray<StoreItem *> *dataSource;
@property (strong, nonatomic) NSArray<StoreItem *> *dataSource2;

@property (strong, nonatomic) NSString *selectedName;
@property (strong, nonatomic) NSString *selectedId;

@end
