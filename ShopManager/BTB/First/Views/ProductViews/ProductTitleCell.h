//
//  ProductTitleCell.h
//  BTB
//
//  Created by 薛焱 on 16/2/16.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UILabel *fiveButton;
@property (weak, nonatomic) IBOutlet UILabel *tenButton;
@property (weak, nonatomic) IBOutlet UILabel *hundredButton;
@property (weak, nonatomic) IBOutlet UILabel *sellCount;

@end
