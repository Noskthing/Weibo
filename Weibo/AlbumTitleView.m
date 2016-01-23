//
//  AlbumTitleView.m
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/23.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "AlbumTitleView.h"

@interface AlbumTitleView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSArray * _models;
}
@end
@implementation AlbumTitleView

-(instancetype)init
{
    if (self = [super init])
    {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return self;
}

-(void)setModels:(NSArray *)models
{
    
    _models = [models mutableCopy];
    [_tableView reloadData];
}

#pragma mark -代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_models)
    {
        return _models.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
