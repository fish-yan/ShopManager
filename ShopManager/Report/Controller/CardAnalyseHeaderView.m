//
//  CardAnalyseHeaderView.m
//  ShopManager
//
//  Created by 张旭 on 20/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "CardAnalyseHeaderView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface CardAnalyseHeaderView () {
	UIView *view;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CardAnalyseHeaderView

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

- (void)initExtra {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"newArea" ofType:@"html"];
	NSURL *url = [NSURL URLWithString:path];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
	self.webView.scrollView.scrollEnabled = NO;
	self.webView.scrollView.backgroundColor = [UIColor whiteColor];
	if (kScreenWidth/2-(NSInteger)(kScreenWidth/2) > 1e-5) {
		self.widthConstraint.constant = self.widthConstraint.constant+0.5;
	}
}

- (void)setJsStr:(NSString *)jsStr {
	_jsStr = jsStr;
	[self.webView reload];
}

- (UIView *)loadFromNib {
	UIView *xibView = [[[UINib nibWithNibName:@"CardAnalyseHeaderView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
	return xibView;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.webView stringByEvaluatingJavaScriptFromString:self.jsStr];
	[UIView animateWithDuration:0.5 animations:^{
		if (self.jsStr != nil && ![self.jsStr isEqualToString:@""]) {
			self.webView.alpha = 1;
		}
	}];
}

@end
