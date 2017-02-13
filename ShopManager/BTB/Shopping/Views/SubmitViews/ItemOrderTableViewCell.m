//
//  ItemOrderTableViewCell.m
//  Cjmczh
//
//  Created by cjm-ios on 15/12/23.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import "ItemOrderTableViewCell.h"

@implementation ItemOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.drawbackButton.layer.borderWidth = 0.5;
    self.drawbackButton.layer.cornerRadius = 3;
    self.drawbackButton.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    self.drawbackButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
