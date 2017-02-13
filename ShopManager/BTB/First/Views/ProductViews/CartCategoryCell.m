//
//  CartCategoryCell.m
//  BTB
//
//  Created by 薛焱 on 16/2/17.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "CartCategoryCell.h"

@implementation CartCategoryCell

- (void)awakeFromNib {
    for (UIButton *button in self.categoryButtons) {
        button.layer.borderColor = UIColorFromRGB(0xc3c3c3).CGColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
