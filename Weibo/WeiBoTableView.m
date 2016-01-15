//
//  WeiBoTableView.m
//  Weibo
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "WeiBoTableView.h"
#import "WeiBoTableViewCell.h"
#import "WeiboModel.h"

@interface WeiBoTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _models;
}
@end
@implementation WeiBoTableView

-(void)setDataModels:(NSArray *)models
{
    _models = models;
//    NSLog(@"_modes.count=%lu",(unsigned long)_models.count);
    [self reloadData];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[WeiBoTableViewCell class] forCellReuseIdentifier:@"WeiBoTableViewCell.h"];
}

#pragma mark  -代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_models)
    {
        return _models.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    WeiBoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WeiBoTableViewCell.h" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_models)
    {
        WeiboModel * model = _models[indexPath.section];
        if (_cellDelegate)
        {
            cell.delegate = _cellDelegate;
        }
        [cell setWeiBoModel:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_models)
    {
        WeiboModel * model = _models[indexPath.section];
        return model.cellHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
@end
