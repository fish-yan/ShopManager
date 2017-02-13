//
//  KZPickerView.m
//  ShopManager
//
//  Created by 张旭 on 03/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "KZPickerView.h"

@interface KZPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate> {
	UIView *view;
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation KZPickerView

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
	UIView *xibView = [[[UINib nibWithNibName:@"KZPickerView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
	return xibView;
}

- (void)initExtra {
	[self.confirmButton addTarget:self action:@selector(confirmButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
	[self.cancelButton addTarget:self action:@selector(cancelButttonDidTouch) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDataSource:(NSArray<NSString *> *)dataSource {
	_dataSource = dataSource;
	[self.pickerView reloadComponent:0];
}

- (void)confirmButtonDidTouch {
	[self.textField resignFirstResponder];
	if (self.confirmBlock) {
		self.confirmBlock([self.pickerView selectedRowInComponent:0]);
	}
}

- (void)cancelButttonDidTouch {
	[self.textField resignFirstResponder];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (component == 0) {
		if (self.dataSource == nil) {
			return 0;
		}
		return self.dataSource.count;
	}
	return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (component == 0) {
		return self.dataSource[row];
	}
	return @"";
}

@end
