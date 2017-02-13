//
//  IndexHeaderCollectionViewCell.m
//  ShopManager
//
//  Created by 张旭 on 18/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "IndexHeaderCollectionViewCell.h"

@interface IndexHeaderCollectionViewCell ()

@end

@implementation IndexHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)buttonDidTouch:(UIButton *)sender {
	if (self.buttonBlock) {
		self.buttonBlock(sender.tag);
	}
}


@end
