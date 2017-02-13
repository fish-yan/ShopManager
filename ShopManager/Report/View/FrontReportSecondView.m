//
//  FrontReportSecondView.m
//  ShopManager
//
//  Created by 张旭 on 10/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "FrontReportSecondView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface FrontReportSecondView ()<UIWebViewDelegate> {
	UIView *view;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray<UIView *> *colorViewArrays;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray<UILabel *> *labelArrays;
@property (weak, nonatomic) IBOutlet UILabel *totalysL;
@property (weak, nonatomic) IBOutlet UILabel *xkL;
@property (weak, nonatomic) IBOutlet UILabel *cysL;
@property (weak, nonatomic) IBOutlet UILabel *ysgzL;

@end

@implementation FrontReportSecondView

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
	UIView *xibView = [[[UINib nibWithNibName:@"FrontReportSecondView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
	return xibView;
}

- (void)initExtra {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"newArea" ofType:@"html"];
	NSURL *url = [NSURL URLWithString:path];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
	self.webView.scrollView.scrollEnabled = NO;
	//['#6495D6', '#8ED267', '#459B69', '#F87562', '#F8B966', '#DE7D38', '#B0693A', '#7E83D6', '#EB7475', '#C680D7', '#969391', '#67D4DA']
	self.colorViewArrays[0].backgroundColor =UIColorFromRGB(0x6495D6);
	self.colorViewArrays[1].backgroundColor =UIColorFromRGB(0x8ED267);
	self.colorViewArrays[2].backgroundColor =UIColorFromRGB(0x459B69);
	self.colorViewArrays[3].backgroundColor =UIColorFromRGB(0xF87562);
	self.colorViewArrays[4].backgroundColor =UIColorFromRGB(0xF8B966);
	self.colorViewArrays[5].backgroundColor =UIColorFromRGB(0xDE7D38);
	self.colorViewArrays[6].backgroundColor =UIColorFromRGB(0xB0693A);
	self.colorViewArrays[7].backgroundColor =UIColorFromRGB(0x7E83D6);
	self.colorViewArrays[8].backgroundColor =UIColorFromRGB(0xEB7475);
	self.colorViewArrays[9].backgroundColor =UIColorFromRGB(0xC680D7);
	self.colorViewArrays[10].backgroundColor =UIColorFromRGB(0x969391);
	self.colorViewArrays[11].backgroundColor =UIColorFromRGB(0x67D4DA);
}

- (void)setJsStr:(NSString *)jsStr {
	_jsStr = jsStr;
	//[self.webView reload];
	[self.webView stringByEvaluatingJavaScriptFromString:self.jsStr];
}

- (void)setViewModel:(FrontReportVM *)viewModel {
	_viewModel = viewModel;
	for (NSInteger i = 0; i < 10; ++i) {
		FrontReportItemVM *item = _viewModel.listDataSource[i];
		self.labelArrays[i].text = [NSString stringWithFormat:@"%.2f", item.ysxkCount-item.cysCount];
		self.labelArrays[i].textColor = item.secondColor;
	}
	self.labelArrays[10].text = [NSString stringWithFormat:@"%.2f", _viewModel.yskCount];
	if (_viewModel.yskCount >= 0) {
		self.labelArrays[10].textColor = [UIColor blackColor];
	} else {
		self.labelArrays[10].textColor = UIColorFromRGB(0x39a63b);
	}
	self.labelArrays[11].text = [NSString stringWithFormat:@"%.2f", _viewModel.bxyskCount+_viewModel.bxyskCount2-_viewModel.bxcysCount];
	if (_viewModel.bxyskCount+_viewModel.bxyskCount2-_viewModel.bxcysCount > 0) {
		self.labelArrays[11].textColor = [UIColor blackColor];
	} else {
		self.labelArrays[11].textColor = UIColorFromRGB(0x39a63b);
	}
	self.totalysL.text = [NSString stringWithFormat:@"%.2f", _viewModel.totalysCount2];
	self.xkL.text = [NSString stringWithFormat:@"%.2f", _viewModel.totalysxkCount];
	self.cysL.text = [NSString stringWithFormat:@"%.2f", _viewModel.totalcysCount];
	self.ysgzL.text = [NSString stringWithFormat:@"%.2f", _viewModel.totalysgzCount];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.webView stringByEvaluatingJavaScriptFromString:self.jsStr];
	[UIView animateWithDuration:0.5 animations:^{
		self.webView.alpha = 1;
//		if (self.jsStr != nil && ![self.jsStr isEqualToString:@""]) {
//			self.webView.alpha = 1;
//		}
	}];
}

@end
