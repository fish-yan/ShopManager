//
//  IndexHeaderVM.h
//  ShopManager
//
//  Created by Xu Zhang on 27/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "RequestViewModel.h"

@interface IndexHeaderChartItemVM : BaseViewModel

@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) CGFloat money;

@end

@interface IndexHeaderVM : RequestViewModel

@property (strong, nonatomic) NSArray<IndexHeaderChartItemVM *> *chartDataSource;

- (void)chartRequestWithCompletion:(void(^)(BOOL success, NSString *jsStr, NSString *message))complete failure:(void(^)())failure;

@end
