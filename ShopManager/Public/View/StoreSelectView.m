//
//  StoreSelectView.m
//  ShopManager
//
//  Created by 张旭 on 28/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "StoreSelectView.h"
#import "StoreList.h"

@interface StoreSelectView ()<UIPickerViewDataSource, UIPickerViewDelegate> {
	UIView *view;
}

@property (weak, nonatomic) IBOutlet UIView *hoverView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


@end

@implementation StoreSelectView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	[self xibSetUp];
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	[self xibSetUp];
	return self;
}

- (void)xibSetUp {
	view = [self loadFromNib];
	view.frame = self.bounds;
	[self addSubview:view];
	[self initExtra];
}

- (UIView *)loadFromNib {
	UIView *xibView = [[[UINib nibWithNibName:@"StoreSelectView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
	return xibView;
}

- (void)initExtra {
	self.alpha = 0;
	self.bottomConstraint.constant = -kScreenHeight;
	[self layoutIfNeeded];
}

- (IBAction)confirmButtonDidTouch:(id)sender {
	[self hide];
	if (self.confirmBlock) {
		NSInteger index = [self.pickerView selectedRowInComponent:0];
		StoreItem *item = [StoreList sharedList].dataSource[index];
		self.confirmBlock(item.name, item.idStr);
	}
}

- (IBAction)cancelButtonDidTouch:(id)sender {
	[self hide];
}

- (void)show {
	self.alpha = 1;
	self.bottomConstraint.constant = 0;
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[self layoutIfNeeded];
	} completion:nil];
}

- (void)hide {
	self.bottomConstraint.constant = -kScreenHeight;
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[self layoutIfNeeded];
	} completion:^(BOOL finished) {
		self.alpha = 0;
	}];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if ([StoreList sharedList].dataSource == nil) {
		return 0;
	}
	return [StoreList sharedList].dataSource.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	StoreItem *item = [StoreList sharedList].dataSource[row];
	return item.name;
}

@end
