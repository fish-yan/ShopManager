//
// Created by 张旭 on 9/6/16.
// Copyright (c) 2016 薛焱. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AdViewModel : NSObject

@property (strong, nonatomic) NSArray<UIImage *> *adImageList;
@property (strong, nonatomic) NSArray<NSString *> *adURLList;
@property (assign, nonatomic) BOOL shouldSkip;

@end