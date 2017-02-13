//
//  IndexStoreBoardVM.h
//  ShopManager
//
//  Created by 张旭 on 25/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface IndexStoreBoardVM : RequestViewModel

@property (strong, nonatomic) NSString *washCarNum;
@property (strong, nonatomic) NSString *comeInNum;
@property (strong, nonatomic) NSString *sectorNum;
@property (strong, nonatomic) NSString *unSettleNum;
@property (strong, nonatomic) NSString *receivableNum;
@property (strong, nonatomic) NSString *profitNum;

@property (strong, nonatomic) NSString *washCarLastNum;
@property (strong, nonatomic) NSString *comeInLastNum;
@property (strong, nonatomic) NSString *sectorLastNum;
@property (strong, nonatomic) NSString *unSettleLastNum;
@property (strong, nonatomic) NSString *receivableLastNum;
@property (strong, nonatomic) NSString *profitLastNum;

@property (assign, nonatomic) NSInteger washCarIsUp;
@property (assign, nonatomic) NSInteger comeInIsUp;
@property (assign, nonatomic) NSInteger sectorIsUp;
@property (assign, nonatomic) NSInteger unSettleIsUp;
@property (assign, nonatomic) NSInteger receivableIsUp;
@property (assign, nonatomic) NSInteger profitIsUp;

@property (strong, nonatomic) NSString *washCarCode;
@property (strong, nonatomic) NSString *comeInCode;
@property (strong, nonatomic) NSString *sectorCode;
@property (strong, nonatomic) NSString *unSettleCode;
@property (strong, nonatomic) NSString *receivableCode;
@property (strong, nonatomic) NSString *profitCode;

- (void)requestWithComplete:(void(^)(BOOL success))complete failure:(void(^)())failure;

@end
