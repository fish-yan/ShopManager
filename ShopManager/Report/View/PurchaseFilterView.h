//
//  PurchaseFilterView.h
//  ShopManager
//
//  Created by 张旭 on 07/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseFilterView : UIView

@property (strong, nonatomic) NSString *startDateText;
@property (strong, nonatomic) NSString *endDateText;

@property (copy, nonatomic) void(^ confirmBlock)(NSString *startDate, NSString *endDate, NSInteger companyIndex, NSString *supplier, BOOL both);

- (void)show;

@end
