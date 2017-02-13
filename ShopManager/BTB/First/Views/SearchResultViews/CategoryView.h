//
//  CategoryView.h
//  BTB
//
//  Created by 薛焱 on 16/2/15.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)();

@interface CategoryView : UIView
@property (weak, nonatomic) IBOutlet UITableView *supTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic, copy) NSDictionary *dataDict;
@property (nonatomic, copy) NSString *categoryUrlStr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthMargin;
@property (nonatomic, copy) MyBlock block;
@end
