//
//  StoreBoardHeaderView.h
//  ShopManager
//
//  Created by 张旭 on 19/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreBoardHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (strong, nonatomic) NSString *jsStr;

@property (copy, nonatomic) void(^ chartBlock)(NSInteger i);

@end
