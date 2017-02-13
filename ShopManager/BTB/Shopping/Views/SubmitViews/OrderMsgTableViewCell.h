//
//  OrderMsgTableViewCell.h
//  Cjmczh
//
//  Created by cjm-ios on 15/12/23.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMsgTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end
