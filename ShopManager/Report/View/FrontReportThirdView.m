//
//  FrontReportThirdView.m
//  ShopManager
//
//  Created by 张旭 on 10/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "FrontReportThirdView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "FrontLegendView.h"

@interface FrontReportThirdView ()<UIWebViewDelegate> {
	UIView *view;
}

@property (weak, nonatomic) IBOutlet UIView *firstContainerView;
@property (weak, nonatomic) IBOutlet UIView *secondContainerView;


@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UILabel *totalL;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray<UIView *> *colorViewArrays;

@end

@implementation FrontReportThirdView

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
	UIView *xibView = [[[UINib nibWithNibName:@"FrontReportThirdView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
	return xibView;
}

- (void)initExtra {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"newArea" ofType:@"html"];
	NSURL *url = [NSURL URLWithString:path];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
	self.webView.scrollView.scrollEnabled = NO;

	//['#6495D6', '#8ED267', '#459B69', '#F87562', '#B0693A', '#7E83D6', '#EB7475', '#C680D7']
	self.colorViewArrays[0].backgroundColor =UIColorFromRGB(0x6495D6);
	self.colorViewArrays[1].backgroundColor =UIColorFromRGB(0x8ED267);
	self.colorViewArrays[2].backgroundColor =UIColorFromRGB(0x459B69);
	self.colorViewArrays[3].backgroundColor =UIColorFromRGB(0xF87562);
	self.colorViewArrays[4].backgroundColor =UIColorFromRGB(0xB0693A);
	self.colorViewArrays[5].backgroundColor =UIColorFromRGB(0x7E83D6);
	self.colorViewArrays[6].backgroundColor =UIColorFromRGB(0xEB7475);
	self.colorViewArrays[7].backgroundColor =UIColorFromRGB(0xC680D7);
}

- (void)setJsStr:(NSString *)jsStr {
	_jsStr = jsStr;
	[self.webView stringByEvaluatingJavaScriptFromString:self.jsStr];
//	[self.webView reload];
}

- (void)setViewModel:(FrontReportVM *)viewModel {
	_viewModel = viewModel;
	//['#6495D6', '#8ED267', '#459B69', '#F87562', '#F8B966', '#B0693A', '#7E83D6', '#EB7475', '#C680D7', '#969391', '#DE7D38', '#67D4DA', '#F6A623', '#F8E81C', '#8B572A', '#7ED321', '#417505', '#4990E2', '#B8E986', '#F1576A', 'D16C62', '#827C8B', '#F2AA43', '#C28155', '#574C8C', '#DCB995']
	NSArray<UIColor *> *colorList = @[UIColorFromRGB(0x6495D6),UIColorFromRGB(0x8ED267),UIColorFromRGB(0x459B69),UIColorFromRGB(0xF87562),UIColorFromRGB(0xF8B966),UIColorFromRGB(0xB0693A),UIColorFromRGB(0x7E83D6),UIColorFromRGB(0xEB7475),UIColorFromRGB(0xC680D7),UIColorFromRGB(0x969391),UIColorFromRGB(0xDE7D38),UIColorFromRGB(0x67D4DA),UIColorFromRGB(0xF6A623),UIColorFromRGB(0xF8E81C),UIColorFromRGB(0x8B572A),UIColorFromRGB(0x7ED321),UIColorFromRGB(0x417505),UIColorFromRGB(0x4990E2),UIColorFromRGB(0xB8E986),UIColorFromRGB(0xF1576A),UIColorFromRGB(0xD16C62),UIColorFromRGB(0x827C8B),UIColorFromRGB(0xF2AA43),UIColorFromRGB(0xC28155),UIColorFromRGB(0x574C8C),UIColorFromRGB(0xDCB995)];
	self.totalL.text = [NSString stringWithFormat:@"%.2f", _viewModel.totalskCount];
	CGRect leftFrame = self.firstContainerView.frame;
	CGRect rightFrame = self.secondContainerView.frame;
	for (UIView *subView in [self.firstContainerView subviews]) {
		[subView removeFromSuperview];
	}
	for (UIView *subView in [self.secondContainerView subviews]) {
		[subView removeFromSuperview];
	}
	if (_viewModel.chartDataSource.count%2 == 1) {
		for (NSInteger i = 0; i < _viewModel.chartDataSource.count; ++i) {
			if (i <= _viewModel.chartDataSource.count/2) {
				FrontLegendView *legend = [[FrontLegendView alloc] initWithFrame:CGRectMake(24, i*49, leftFrame.size.width-36, 34)];
				legend.titleL.text = _viewModel.chartDataSource[i].type;
				legend.monelyL.text = [NSString stringWithFormat:@"%.2f", _viewModel.chartDataSource[i].money];
				if (i < colorList.count) {
					legend.circleView.backgroundColor = colorList[i];
				}
				[self.firstContainerView addSubview:legend];
			} else {
				FrontLegendView *legend = [[FrontLegendView alloc] initWithFrame:CGRectMake(12, (i-_viewModel.chartDataSource.count/2-1)*49, rightFrame.size.width-36, 34)];
				legend.titleL.text = _viewModel.chartDataSource[i].type;
				legend.monelyL.text = [NSString stringWithFormat:@"%.2f", _viewModel.chartDataSource[i].money];
				if (i < colorList.count) {
					legend.circleView.backgroundColor = colorList[i];
				}
				[self.secondContainerView addSubview:legend];
			}
		}
	} else {
		for (NSInteger i = 0; i < _viewModel.chartDataSource.count; ++i) {
			if (i < _viewModel.chartDataSource.count/2) {
				FrontLegendView *legend = [[FrontLegendView alloc] initWithFrame:CGRectMake(24, i*49, leftFrame.size.width-36, 34)];
				legend.titleL.text = _viewModel.chartDataSource[i].type;
				legend.monelyL.text = [NSString stringWithFormat:@"%.2f", _viewModel.chartDataSource[i].money];
				if (i < colorList.count) {
					legend.circleView.backgroundColor = colorList[i];
				}
				[self.firstContainerView addSubview:legend];
			} else {
				FrontLegendView *legend = [[FrontLegendView alloc] initWithFrame:CGRectMake(12, (i-_viewModel.chartDataSource.count/2)*49, rightFrame.size.width-36, 34)];
				legend.titleL.text = _viewModel.chartDataSource[i].type;
				legend.monelyL.text = [NSString stringWithFormat:@"%.2f", _viewModel.chartDataSource[i].money];
				if (i < colorList.count) {
					legend.circleView.backgroundColor = colorList[i];
				}
				[self.secondContainerView addSubview:legend];
			}
		}
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
