//
//  SaleAnalyseFilterView.h
//  ShopManager
//
//  Created by 张旭 on 09/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleAnalyseFilterView : UIView

@property (strong, nonatomic) NSString *startDateText;
@property (strong, nonatomic) NSString *endDateText;

- (void)show;

@property (copy, nonatomic) void(^ confirmBlock)(NSString * startDate, NSString *endDate, NSInteger storeIndex, NSInteger statisticType, BOOL both);

@end
