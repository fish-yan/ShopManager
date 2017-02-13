//
//  FrontLegendView.m
//  ShopManager
//
//  Created by 张旭 on 24/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "FrontLegendView.h"

@interface FrontLegendView () {
	UIView *view;
}

@end

@implementation FrontLegendView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	[self xibSetup];
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	[self xibSetup];
	return self;
}

- (void)xibSetup {
	view = [self loadFromNib];
	view.frame = self.bounds;
	[self addSubview:view];
	[self initExtra];
}

- (UIView *)loadFromNib {
	UIView *xibView = [[[UINib nibWithNibName:@"FrontLegendView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
	return xibView;
}

- (void)initExtra {
	self.circleView.layer.cornerRadius = 8.5;
}

@end
