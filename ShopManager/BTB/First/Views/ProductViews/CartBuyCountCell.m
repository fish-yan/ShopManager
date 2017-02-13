//
//  CartBuyCountCell.m
//  BTB
//
//  Created by 薛焱 on 16/2/17.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "CartBuyCountCell.h"

@implementation CartBuyCountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addButtonAction:(UIButton *)sender {
    NSInteger count = [self.countTF.text integerValue];
    count++;
    self.countTF.text = [NSString stringWithFormat:@"%ld", count];
    if (count > 0) {
        self.minusButton.userInteractionEnabled = YES;
    }
}
- (IBAction)minusButtonAction:(UIButton *)sender {
    NSInteger count = [self.countTF.text integerValue];
    count--;
    self.countTF.text = [NSString stringWithFormat:@"%ld", count];
    if (count <= 0) {
        self.minusButton.userInteractionEnabled = NO;
    }
}

@end
