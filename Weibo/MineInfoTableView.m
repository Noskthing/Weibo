//
//  MineInfoTableView.m
//  Weibo
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "MineInfoTableView.h"

@interface MineInfoTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@end
@implementation MineInfoTableView

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MineInfoTableView.h"];
    
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark  -代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 3)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MineInfoTableView.h" forIndexPath:indexPath];
    
    return cell;
}



@end
