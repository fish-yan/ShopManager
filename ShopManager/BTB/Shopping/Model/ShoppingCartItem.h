//
//  ShoppingCartItem.h
//  Cjmczh
//
//  Created by 张旭 on 1/28/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartItem : NSObject

@property (assign, nonatomic) BOOL isSelected;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) CGFloat price;
@property (assign, nonatomic) NSInteger amount;
@property (strong, nonatomic) NSString *id;

@end
