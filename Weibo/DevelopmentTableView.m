//
//  DevelopmentTableView.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "DevelopmentTableView.h"
#import "DevelopmentTableViewCell.h"
@interface DevelopmentTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@end

@implementation DevelopmentTableView

-(void)setSymbol:(NSInteger)symbol
{
    _symbol = symbol;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    self.delegate = self;
    self.dataSource = self;
    self.rowHeight = 80;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerNib:[UINib nibWithNibName:@"DevelopmentTableViewCell" bundle:nil] forCellReuseIdentifier:@"DevelopmentTableViewCell.h"];
}


#pragma mark   -代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DevelopmentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DevelopmentTableViewCell.h" forIndexPath:indexPath];
    
    
    [cell setFollowingSymbol:_symbol];
    
    return cell;
}

@end
