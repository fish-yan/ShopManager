//
//  CardAnalyseFilterView.h
//  ShopManager
//
//  Created by 张旭 on 20/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardAnalyseFilterView : UIView

- (void)show;

@property (strong, nonatomic) NSString *startDateText;
@property (strong, nonatomic) NSString *endDateText;

@property (copy, nonatomic) void(^ confirmBlock)(NSString *startDate, NSString *endDate, NSInteger storeIndex, BOOL both);

@end
