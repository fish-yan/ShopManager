//
//  StoreBoardFilterView.m
//  ShopManager
//
//  Created by 张旭 on 03/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "StoreBoardFilterView.h"
#import "KZDatePicker.h"
#import "StoreList.h"
#import "KZPickerView.h"

@import DateTools;

@interface StoreBoardFilterView () {
	UIView *view;
}

@property (weak, nonatomic) IBOutlet UITextField *startField;
@property (weak, nonatomic) IBOutlet UITextField *endField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (assign, nonatomic) NSInteger index;

@end

@implementation StoreBoardFilterView

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

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type {
	self = [super initWithFrame:frame];
	self.type = type;
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
	UIView *xibView = [[[UINib nibWithNibName:@"StoreBoardFilterView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
	return xibView;
}

- (void)initExtra {
	[self.confirmButton addTarget:self action:@selector(confirmButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
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

	KZPickerView *picker = [[KZPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
	NSMutableArray<NSString *> *dataSource = [NSMutableArray array];
	if (_type == 0) {
		for (StoreItem *item in [StoreList sharedList].dataSource) {
			[dataSource addObject:item.name];
		}
	} else {
		for (StoreItem *item in [StoreList sharedList].dataSource2) {
			[dataSource addObject:item.name];
		}
	}
	picker.dataSource = dataSource;
	picker.confirmBlock = ^(NSInteger index) {
		self.index = index;
	};
	self.companyField.inputView = picker;
	picker.textField = self.companyField;

	_index = -1;

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

- (void)setIndex:(NSInteger)index {
	_index = index;
	NSString *str = @"";
	if (self.type == 0) {
		str = [StoreList sharedList].dataSource[index].name;
	} else {
		str = [StoreList sharedList].dataSource2[index].name;
	}
	self.companyField.text = str;
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
		self.confirmBlock(self.startField.text, self.endField.text, self.index);
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

@end
