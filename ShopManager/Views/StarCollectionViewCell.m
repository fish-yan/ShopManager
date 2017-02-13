//
//  StarCollectionViewCell.m
//  ShopManager
//
//  Created by 张旭 on 2/24/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "StarCollectionViewCell.h"

@implementation StarCollectionViewCell

- (void)awakeFromNib {
    self.starWidth = self.starWidthConstraint.constant;
}

@end
