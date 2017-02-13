//
//  ClientBoardHeaderView.h
//  ShopManager
//
//  Created by 张旭 on 06/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientBoardHeaderView : UIView
@property (strong, nonatomic) IBOutlet UILabel *nameL;

@property (strong, nonatomic) NSString *jsStr;

@property (copy, nonatomic) void(^ chartBlock)(NSInteger i);

@end
