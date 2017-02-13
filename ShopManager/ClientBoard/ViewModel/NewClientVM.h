//
//  NewClientVM.h
//  ShopManager
//
//  Created by 张旭 on 04/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface NewClientItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *carNum;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *storeName;

@end

@interface NewClientVM : RequestViewModel

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;
@property (assign, nonatomic) NSInteger currentPage;

- (void)listRequestWithComplete:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

@property (strong, nonatomic) NSArray<NewClientItemVM *> *dataSource;

@end
