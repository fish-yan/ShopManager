//
//  KZPickerView.h
//  ShopManager
//
//  Created by 张旭 on 03/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZPickerView : UIView

@property (weak, nonatomic) UITextField *textField;

@property (strong, nonatomic) NSArray<NSString *> *dataSource;

@property (copy, nonatomic) void(^ confirmBlock)(NSInteger index);

@end
