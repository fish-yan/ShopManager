//
//  ClientLevelTableViewCell.m
//  ShopManager
//
//  Created by 张旭 on 19/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "ClientLevelTableViewCell.h"

@interface ClientLevelTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation ClientLevelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStar:(CGFloat)star {
	_star = star;
	self.widthConstraint.constant = 50*(_star/5.0);
	[self layoutIfNeeded];
}

- (IBAction)buttonDidTouch:(id)sender {
	if (self.clickBlock) {
		self.clickBlock();
	}
}

@end
