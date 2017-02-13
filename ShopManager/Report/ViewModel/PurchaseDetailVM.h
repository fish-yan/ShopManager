//
//  PurchaseDetailVM.h
//  ShopManager
//
//  Created by 张旭 on 17/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface PurchaseDetailItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) CGFloat price;
@property (assign, nonatomic) CGFloat totalPrice;
@property (assign, nonatomic) NSInteger num;
@property (strong, nonatomic) NSString *settleType;
@property (strong, nonatomic) NSString *orderType;
@property (strong, nonatomic) NSString *time;

@end

@interface PurchaseDetailVM : RequestViewModel

@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *showTime;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;
@property (assign, nonatomic) NSInteger currentPage;

@property (strong, nonatomic) NSString *supplier;
@property (strong, nonatomic) NSString *supplierId;

@property (strong, nonatomic) NSString *keyVal;
@property (strong, nonatomic) NSString *storageName;
@property (strong, nonatomic) NSString *settleType;
@property (strong, nonatomic) NSString *orderType;

@property (strong, nonatomic) NSArray<PurchaseDetailItemVM *> *listDataSource;

- (void)listRequestWithCompletion:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

@end
