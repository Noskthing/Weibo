//
//  MessageTableView.m
//  Weibo
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "MessageTableView.h"

@interface MessageTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _imageNames;
    NSArray * _titles;
}
@end
@implementation MessageTableView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    _imageNames = @[@"messagescenter_at",@"messagescenter_comments",@"messagescenter_good",@"messagescenter_subscription",@"messagescenter_messagebox"];
    _titles = @[@"@我的",@"评论",@"赞",@"订阅消息",@"未关注人的消息"];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.rowHeight = 60;
    
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MessageTableViewCell"];
}

#pragma mark  -代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:_imageNames[indexPath.row]];
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}

@end
