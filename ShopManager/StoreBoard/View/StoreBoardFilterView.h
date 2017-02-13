//
//  StoreBoardFilterView.h
//  ShopManager
//
//  Created by 张旭 on 03/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreBoardFilterView : UIView

@property (strong, nonatomic) NSString *startDateText;
@property (strong, nonatomic) NSString *endDateText;

@property (assign, nonatomic) NSInteger type;

@property (copy, nonatomic) void(^ confirmBlock)(NSString *startDate, NSString *endDate, NSInteger companyIndex);

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;

- (void)show;

@end
