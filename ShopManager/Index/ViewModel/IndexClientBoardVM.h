//
//  IndexClientBoardVM.h
//  ShopManager
//
//  Created by 张旭 on 25/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface IndexClientBoardVM : RequestViewModel

@property (strong, nonatomic) NSString *serviceClientNum;
@property (strong, nonatomic) NSString *newlyClientNum;
@property (strong, nonatomic) NSString *preLoseClientNum;
@property (strong, nonatomic) NSString *loseClientNum;
@property (strong, nonatomic) NSString *starClientNum;
@property (strong, nonatomic) NSString *adoptClientNum;

@property (assign, nonatomic) NSInteger serviceClientIsUp;
@property (assign, nonatomic) NSInteger newlyClientIsUp;
@property (assign, nonatomic) NSInteger preLoseClientIsUp;
@property (assign, nonatomic) NSInteger loseClientIsUp;
@property (assign, nonatomic) NSInteger starClientIsUp;
@property (assign, nonatomic) NSInteger adoptClientIsUp;

@property (strong, nonatomic) NSString *serviceClientCode;
@property (strong, nonatomic) NSString *newlyClientCode;
@property (strong, nonatomic) NSString *preLoseClientCode;
@property (strong, nonatomic) NSString *loseClientCode;
@property (strong, nonatomic) NSString *starClientCode;
@property (strong, nonatomic) NSString *adoptClientCode;

- (void)requestWithComplete:(void(^)(BOOL success))complete failure:(void(^)())failure;

@end
