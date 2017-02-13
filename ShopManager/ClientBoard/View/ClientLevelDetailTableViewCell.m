//
//  ClientLevelDetailTableViewCell.m
//  ShopManager
//
//  Created by 张旭 on 06/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "ClientLevelDetailTableViewCell.h"

@interface ClientLevelDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xcWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mrWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jxWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bxWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ltWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bpWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ypWidth;

@end

@implementation ClientLevelDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setXcStar:(CGFloat)xcStar {
	_xcStar = xcStar;
	self.xcWidth.constant = 50*(_xcStar/5.0);
	[self layoutIfNeeded];
}

- (void)setMrStar:(CGFloat)mrStar {
	_mrStar = mrStar;
	self.mrWidth.constant = 50*(_mrStar/5.0);
	[self layoutIfNeeded];
}

- (void)setJxStar:(CGFloat)jxStar {
	_jxStar = jxStar;
	self.jxWidth.constant = 50*(_jxStar/5.0);
	[self layoutIfNeeded];
}

- (void)setBxStar:(CGFloat)bxStar {
	_bxStar = bxStar;
	self.bxWidth.constant = 50*(_bxStar/5.0);
	[self layoutIfNeeded];
}

- (void)setLtStar:(CGFloat)ltStar {
	_ltStar = ltStar;
	self.ltWidth.constant = 50*(_ltStar/5.0);
	[self layoutIfNeeded];
}

- (void)setBpStar:(CGFloat)bpStar {
	_bpStar = bpStar;
	self.bpWidth.constant = 50*(_bpStar/5.0);
	[self layoutIfNeeded];
}

- (void)setYpStar:(CGFloat)ypStar {
	_ypStar = ypStar;
	self.ypWidth.constant = 50*(_ypStar/5.0);
	[self layoutIfNeeded];
}

@end
