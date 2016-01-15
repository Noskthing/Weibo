//
//  WeiboTypeTableView.m
//  Weibo
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "WeiboTypeTableView.h"

@interface WeiboTypeTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@end
@implementation WeiboTypeTableView


-(void)willMoveToSuperview:(UIView *)newSuperview
{
    self.delegate = self;
    self.dataSource = self;
    
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"weibotyoe"];
}

#pragma mark  -代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"weibotyoe" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"新浪微博";
    return cell;
}
@end
