//
//  PurchaseDetailFilterView.m
//  ShopManager
//
//  Created by 张旭 on 07/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "PurchaseDetailFilterView.h"
#import "KZDatePicker.h"
#import "StoreList.h"
#import "KZPickerView.h"

@interface PurchaseDetailFilterView ()<UITextFieldDelegate> {
	UIView *view;
}

@property (weak, nonatomic) IBOutlet UITextField *startField;
@property (weak, nonatomic) IBOutlet UITextField *endField;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITextField *storageField;
@property (weak, nonatomic) IBOutlet UIButton *radioButton1;
@property (weak, nonatomic) IBOutlet UIButton *radioButton2;
@property (weak, nonatomic) IBOutlet UIButton *radioButton3;
@property (weak, nonatomic) IBOutlet UIButton *radioButton4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@property (strong, nonatomic) NSString *settleType;
@property (strong, nonatomic) NSString *orderType;

@end

@implementation PurchaseDetailFilterView

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
	UIView *xibView = [[[UINib nibWithNibName:@"PurchaseDetailFilterView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
	return xibView;
}

- (void)initExtra {
	[self.confirmButton addTarget:self action:@selector(confirmButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
	[self.radioButton1 addTarget:self action:@selector(settleTypeButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
	[self.radioButton2 addTarget:self action:@selector(settleTypeButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
	[self.radioButton3 addTarget:self action:@selector(orderTypeButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
	[self.radioButton4 addTarget:self action:@selector(orderTypeButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
	[self addGestureRecognizer:tap];
	KZDatePicker *startPicker = [[KZDatePicker alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
	startPicker.confirmBlock = ^(NSDate *date) {
		self.startDate = date;
	};
	self.startField.inputView = startPicker;
	startPicker.textField = self.startField;

	KZDatePicker *endPicker = [[KZDatePicker alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
	endPicker.confirmBlock = ^(NSDate *date) {
		self.endDate = date;
	};
	self.endField.inputView = endPicker;
	endPicker.textField = self.endField;

	self.settleType = @"现购";
	self.orderType = @"采购入库";

	self.alpha = 0;
	self.topConstraint.constant = -kScreenHeight;
	[self layoutIfNeeded];
}

- (void)setStartDate:(NSDate *)startDate {
	_startDate = startDate;
	NSString *str = [NSString stringWithFormat:@"%zd-%02zd-%02zd", _startDate.year, _startDate.month, _startDate.day];
	self.startField.text = str;
}

- (void)setStartDateText:(NSString *)startDateText {
	_startDateText = startDateText;
	NSArray<NSString *> *dateFragment = [_startDateText componentsSeparatedByString:@"-"];
	self.startDate = [NSDate dateWithYear:[dateFragment[0] integerValue] month:[dateFragment[1] integerValue] day:[dateFragment[2] integerValue]];
}

- (void)setEndDate:(NSDate *)endDate {
	_endDate = endDate;
	NSString *str = [NSString stringWithFormat:@"%zd-%02zd-%02zd", _endDate.year, _endDate.month, _endDate.day];
	self.endField.text = str;
}

- (void)setEndDateText:(NSString *)endDateText {
	_endDateText = endDateText;
	NSArray<NSString *> *dateFragment = [_endDateText componentsSeparatedByString:@"-"];
	self.endDate = [NSDate dateWithYear:[dateFragment[0] integerValue] month:[dateFragment[1] integerValue] day:[dateFragment[2] integerValue]];
}

- (void)settleTypeButtonDidTouch:(UIButton *)sender {
	if (sender.tag == 0) {
		[self.radioButton1 setImage:[UIImage imageNamed:@"btn_y"] forState:UIControlStateNormal];
		[self.radioButton2 setImage:[UIImage imageNamed:@"btn_n"] forState:UIControlStateNormal];
		self.settleType = @"现购";
	} else if (sender.tag == 1) {
		[self.radioButton1 setImage:[UIImage imageNamed:@"btn_n"] forState:UIControlStateNormal];
		[self.radioButton2 setImage:[UIImage imageNamed:@"btn_y"] forState:UIControlStateNormal];
		self.settleType = @"赊购";
	}
}

- (void)orderTypeButtonDidTouch:(UIButton *)sender {
	if (sender.tag == 0) {
		[self.radioButton3 setImage:[UIImage imageNamed:@"btn_y"] forState:UIControlStateNormal];
		[self.radioButton4 setImage:[UIImage imageNamed:@"btn_n"] forState:UIControlStateNormal];
		self.orderType = @"采购入库";
	} else if (sender.tag == 1) {
		[self.radioButton3 setImage:[UIImage imageNamed:@"btn_n"] forState:UIControlStateNormal];
		[self.radioButton4 setImage:[UIImage imageNamed:@"btn_y"] forState:UIControlStateNormal];
		self.orderType = @"采购退货";
	}
}

- (void)confirmButtonDidTouch {
	if (self.startDate == nil || self.endDate == nil) {
		[self makeToast:@"日期选择错误" duration:2 position:CSToastPositionCenter];
		return;
	}
	NSInteger day = [_endDate daysFrom:_startDate];
	if (day > 31) {
		[self makeToast:@"最多只能查一个月数据" duration:2 position:CSToastPositionCenter];
		return;
	} else if (day < 0) {
		[self makeToast:@"日期选择错误" duration:2 position:CSToastPositionCenter];
		return;
	}
	[self hide];
	if (self.confirmBlock) {
		self.confirmBlock(self.startField.text, self.endField.text, self.searchField.text, self.storageField.text, self.settleType, self.orderType);
	}
}

- (void)show {
	self.topConstraint.constant = 0;
	self.alpha = 1;
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[self layoutIfNeeded];
	} completion:nil];
}

- (void)hide {
	[self endEditing:YES];
	self.topConstraint.constant = -kScreenHeight;
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[self layoutIfNeeded];
	} completion:^(BOOL finished) {
		self.alpha = 0;
	}];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
