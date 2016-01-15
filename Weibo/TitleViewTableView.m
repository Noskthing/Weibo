//
//  TitleViewTableView.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "TitleViewTableView.h"
#import "TitleViewHeader.h"


@interface TitleViewTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    CellDidSeletcedBlock _block;
    NSArray * _titles;
}
@end

@implementation TitleViewTableView


-(void)setTitles:(NSArray *)titles
{
    _titles = titles;
    [self reloadData];
}

-(void)setCellDidSelectedBlock:(CellDidSeletcedBlock)block
{
    _block = block;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rowHeight = 40;
    
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TitleViewTableView"];
}

#pragma mark  -代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_titles)
    {
        NSArray * arr = _titles[section];
        return arr.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    if (_titles)
    {
        return _titles.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TitleViewTableView" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18 weight:1.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor orangeColor];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    bgView.image = [UIImage imageNamed:@"popover_noarrow_background"];
    cell.selectedBackgroundView = bgView;
   
    
    NSArray * arr = _titles[indexPath.section];
    cell.textLabel.text = arr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_block)
    {
        _block(indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    if (section == 0)
    {
        return nil;
    }
    
    TitleViewHeader * headerView = [TitleViewHeader titleViewHeader];
    switch (section)
    {
        case 1:
        {
            [headerView setTitle:@"我的分组"];
        }
            break;
        case 2:
        {
            [headerView setTitle:@"其他"];
        }
            break;
            
        default:
            break;
    }
    
    return headerView;
}
@end
