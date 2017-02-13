//
//  CategoryView.m
//  BTB
//
//  Created by 薛焱 on 16/2/15.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "CategoryView.h"
#import "CategoryModel.h"

@interface CategoryView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSIndexPath *supCurrentIndexPath;
@end

@implementation CategoryView

- (void)awakeFromNib{
    self.supCurrentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.subTableView.delegate = self;
    self.subTableView.dataSource = self;
    self.supTableView.delegate = self;
    self.supTableView.dataSource = self;
    [self.supTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:(UITableViewScrollPositionNone)];
    [self readDataSource];
}

- (void)readDataSource{
    [DataHelper loadDataWithSuffixUrlStr:kCategory parameters:nil block:^(id responseObject) {
        NSDictionary *dict = [DataHelper praserCategoryDataWithResponseObject:responseObject];
        self.dataDict = dict;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.supTableView reloadData];
            [self.subTableView reloadData];
        });
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.supTableView) {
        return self.dataDict.allKeys.count;
    }else{
        return [self.dataDict[self.dataDict.allKeys[self.supCurrentIndexPath.row]]count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (tableView == self.supTableView) {
        cell.textLabel.text = self.dataDict.allKeys[indexPath.row];
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xe8e8e8);
        
    } else {
        cell.backgroundColor = [UIColor clearColor];
        CategoryModel *model = self.dataDict[self.dataDict.allKeys[self.supCurrentIndexPath.row]][indexPath.row];
        cell.textLabel.text = model.name;
    }
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.supTableView) {
        self.supCurrentIndexPath = indexPath;
        [self.subTableView reloadData];
    }else{
        self.block();
        self.hidden = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.hidden = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
