//
//  KZDatePicker.m
//  ShopManager
//
//  Created by 张旭 on 03/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "KZDatePicker.h"

@interface KZDatePicker (){
	UIView *view;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation KZDatePicker

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
	UIView *xibView = [[[UINib nibWithNibName:@"KZDatePicker" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
	return xibView;
}

- (void)initExtra {
	[self.confirmButton addTarget:self action:@selector(confirmButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
	[self.cancelButton addTarget:self action:@selector(cancelButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
}

- (void)confirmButtonDidTouch {
	[self.textField resignFirstResponder];
	if (self.confirmBlock) {
		self.confirmBlock(self.datePicker.date);
	}
}

- (void)cancelButtonDidTouch {
	[self.textField resignFirstResponder];
}

@end
