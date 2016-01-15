//
//  MineTableView.m
//  Weibo
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "MineTableView.h"
#import "MineHeaderTableViewCell.h"
#import "MineTableViewCell.h"
@interface MineTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    CellDidSeletcedBlock _block;
    NSArray * _models;
}
@end
@implementation MineTableView

//读取本地json数据
-(void)getDataFromJson
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"MineTableViewTitle.json" ofType:nil];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    _models = dict[@"cards"];
    [self reloadData];
}

-(void)setCellDidSeletcedBlock:(CellDidSeletcedBlock)block
{
    _block = block;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self getDataFromJson];
    
    self.delegate = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"MineHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineHeaderTableViewCell.h"];
    [self registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineTableViewCell.h"];
}

#pragma mark  -代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 1;
            break;
        case 5:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MineHeaderTableViewCell.h" forIndexPath:indexPath];
        MineHeaderTableViewCell * headerCell = (MineHeaderTableViewCell *)cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [headerCell reload];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell.h" forIndexPath:indexPath];
        
        if (_models)
        {
            NSDictionary * dict = _models[indexPath.section-1];
            NSArray * array = dict[@"card_group"];
            
            MineTableViewCell * tableCell = (MineTableViewCell *)cell;
            [tableCell reloadDataWithDictionary:array[indexPath.row]];
        }
        
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 130;
    }
    else
    {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 13;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_block)
    {
        _block(indexPath.section*10 + indexPath.row);
    }
}
@end
