//
//  ValuationStarCell.m
//  BTB
//
//  Created by 薛焱 on 16/2/17.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "ValuationStarCell.h"



@implementation ValuationStarCell

- (void)awakeFromNib {
    [self.starView setImageDeselected:@"nostared" halfSelected:nil fullSelected:@"stared" andDelegate:self];
    // Initialization code
}


- (void)ratingChanged:(float)newRating{
    //    newRating = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
