//
//  BirthdayVM.h
//  ShopManager
//
//  Created by 张旭 on 25/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface BirthdayItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *adopter;

@end

@interface BirthdayVM : RequestViewModel

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;
@property (assign, nonatomic) NSInteger currentPage;

- (void)requestWithComplete:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

@property (strong, nonatomic) NSArray<BirthdayItemVM *> *dataSource;

@end
