//
//  FrontReportFirstView.m
//  ShopManager
//
//  Created by 张旭 on 10/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "FrontReportFirstView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface FrontReportFirstView ()<UIWebViewDelegate> {
	UIView *view;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *detailButton;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray<UIView *> *colorViewArrays;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray<UILabel *> *labelArrays;
@property (weak, nonatomic) IBOutlet UILabel *totalysL;
@property (weak, nonatomic) IBOutlet UILabel *xkL;
@property (weak, nonatomic) IBOutlet UILabel *txkL;
@property (weak, nonatomic) IBOutlet UILabel *gzL;
@property (weak, nonatomic) IBOutlet UILabel *tgzL;

@end

@implementation FrontReportFirstView

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
	UIView *xibView = [[[UINib nibWithNibName:@"FrontReportFirstView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
	return xibView;
}

- (void)initExtra {
	[self.detailButton addTarget:self action:@selector(detailButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"newArea" ofType:@"html"];
	NSURL *url = [NSURL URLWithString:path];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
	self.webView.scrollView.scrollEnabled = NO;
	//['#6495D6', '#8ED267', '#459B69', '#F87562', '#F8B966', '#B0693A', '#7E83D6', '#EB7475', '#C680D7', '#969391']
	self.colorViewArrays[0].backgroundColor =UIColorFromRGB(0x6495D6);
	self.colorViewArrays[1].backgroundColor =UIColorFromRGB(0x8ED267);
	self.colorViewArrays[2].backgroundColor =UIColorFromRGB(0x459B69);
	self.colorViewArrays[3].backgroundColor =UIColorFromRGB(0xF87562);
	self.colorViewArrays[4].backgroundColor =UIColorFromRGB(0xF8B966);
	self.colorViewArrays[5].backgroundColor =UIColorFromRGB(0xB0693A);
	self.colorViewArrays[6].backgroundColor =UIColorFromRGB(0x7E83D6);
	self.colorViewArrays[7].backgroundColor =UIColorFromRGB(0xEB7475);
	self.colorViewArrays[8].backgroundColor =UIColorFromRGB(0xC680D7);
	self.colorViewArrays[9].backgroundColor =UIColorFromRGB(0x969391);
}

- (void)setJsStr:(NSString *)jsStr {
	_jsStr = jsStr;
	[self.webView stringByEvaluatingJavaScriptFromString:self.jsStr];
	//[self.webView reload];
}

- (void)setViewModel:(FrontReportVM *)viewModel {
	_viewModel = viewModel;
	for (NSInteger i = 0; i < 10; ++i) {
		FrontReportItemVM *item = _viewModel.listDataSource[i];
		self.labelArrays[i].text = [NSString stringWithFormat:@"%.2f", item.xkCount+item.gzCount];
		self.labelArrays[i].textColor = item.firstColor;
	}
	self.totalysL.text = [NSString stringWithFormat:@"%.2f", _viewModel.totalysCount];
	self.xkL.text = [NSString stringWithFormat:@"%.2f", _viewModel.totalxkCount];
	self.txkL.text = [NSString stringWithFormat:@"%.2f", _viewModel.totaltxkCount];
	self.gzL.text = [NSString stringWithFormat:@"%.2f", _viewModel.totalgzCount];
	self.tgzL.text = [NSString stringWithFormat:@"%.2f", _viewModel.totaltgzCount];
}

- (void)detailButtonDidTouch {
	if (self.detailBlock) {
		self.detailBlock();
	}
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
