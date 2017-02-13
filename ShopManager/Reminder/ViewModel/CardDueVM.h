//
//  CardDueVM.h
//  ShopManager
//
//  Created by 张旭 on 26/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface CardDueItemVM : BaseViewModel

@property (strong, nonatomic) NSString *carNum;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *dueTime;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *cardName;

@end

@interface CardDueVM : RequestViewModel

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;
@property (assign, nonatomic) NSInteger currentPage;

- (void)requestWithComplete:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

@property (strong, nonatomic) NSArray<CardDueItemVM *> *dataSource;

@end
