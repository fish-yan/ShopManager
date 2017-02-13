//
//  SaleAnalyseHeaderView.m
//  ShopManager
//
//  Created by 张旭 on 09/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "SaleAnalyseHeaderView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface SaleAnalyseHeaderView ()<UIWebViewDelegate> {
	UIView *view;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SaleAnalyseHeaderView

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
}

- (void)setJsStr:(NSString *)jsStr {
	_jsStr = jsStr;
	[self.webView reload];
}

- (UIView *)loadFromNib {
	UIView *xibView = [[[UINib nibWithNibName:@"SaleAnalyseHeaderView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
	return xibView;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
	context[@"clickIndex"] = ^() {

		NSArray *args = [JSContext currentArguments];
		JSValue *jsVal = args[0];
		NSInteger index = [jsVal toInt32];
		
	};
	[self.webView stringByEvaluatingJavaScriptFromString:self.jsStr];
	[UIView animateWithDuration:0.5 animations:^{
		if (self.jsStr != nil && ![self.jsStr isEqualToString:@""]) {
			self.webView.alpha = 1;
		}
	}];
}

@end
