//
//  SaleAnalyseDetailFilterView.h
//  ShopManager
//
//  Created by 张旭 on 09/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleAnalyseDetailFilterView : UIView

- (void)show;

@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString *startDateText;
@property (strong, nonatomic) NSString *endDateText;

@property (copy, nonatomic) void(^ confirmBlock)(NSString * startDate, NSString *endDate, NSInteger storeIndex, NSInteger statisticType);

@end
