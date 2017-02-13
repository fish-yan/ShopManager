//
//  KZDatePicker.h
//  ShopManager
//
//  Created by 张旭 on 03/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZDatePicker : UIView

@property (weak, nonatomic) UITextField *textField;

@property (copy, nonatomic) void(^ confirmBlock)(NSDate *date);

@end
