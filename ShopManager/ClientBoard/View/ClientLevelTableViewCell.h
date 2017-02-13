//
//  ClientLevelTableViewCell.h
//  ShopManager
//
//  Created by 张旭 on 19/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientLevelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *adoptL;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (assign, nonatomic) CGFloat star;

@property (copy, nonatomic) void(^ clickBlock)();

@end
