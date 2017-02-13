//
//  OnBoardDetailVM.h
//  ShopManager
//
//  Created by 张旭 on 03/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface OnBoardDetailItemVM : BaseViewModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *carNum;
@property (strong, nonatomic) NSString *phone;

@end

@interface OnBoardDetailVM : RequestViewModel

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeId;
@property (assign, nonatomic) NSInteger currentPage;

- (void)listRequestWithComplete:(void(^)(BOOL success, NSString *message))complete failure:(void(^)())failure;

@property (strong, nonatomic) NSArray<OnBoardDetailItemVM *> *dataSource;

@end
