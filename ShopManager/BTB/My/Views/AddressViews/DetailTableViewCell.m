//
//  DetailTableViewCell.m
//  Cjmczh
//
//  Created by 张旭 on 12/16/15.
//  Copyright © 2015 Cjm. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (void)awakeFromNib {
    self.menuLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
