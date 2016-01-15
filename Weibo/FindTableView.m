//
//  FindTableView.m
//  Weibo
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "FindTableView.h"
#import "MineTableViewCell.h"
#import "AdvertisementTableViewCell.h"
#import "HotTopicTableViewCell.h"

@interface FindTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _models;
    CGFloat _height;
}
@end
@implementation FindTableView

//读取本地json数据
-(void)getDataFromJson
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"FindJson.json" ofType:nil];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    _models = dict[@"cards"];
    CGRect rect = [[UIApplication sharedApplication] keyWindow].frame;
    _height = rect.size.width * 172 / 640;
    [self reloadData];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self getDataFromJson];
    
    self.delegate = self;
    self.dataSource = self;
    
    [self registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineTableViewCell"];
    [self registerClass:[AdvertisementTableViewCell class] forCellReuseIdentifier:@"AdvertisementTableViewCell.h"];
    
    [self registerNib:[UINib nibWithNibName:@"HotTopicTableViewCell" bundle:nil] forCellReuseIdentifier:@"HotTopicTableViewCell.h"];
    
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
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 7;
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    NSDictionary * dict = _models[indexPath.section];
    NSArray * array = dict[@"card_group"];
    
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AdvertisementTableViewCell.h" forIndexPath:indexPath];
        NSDictionary * tmpDict = array[0];
        NSArray * pic_items = tmpDict[@"pic_items"];
        AdvertisementTableViewCell * adverCell = (AdvertisementTableViewCell *)cell;
        [adverCell setViewsArray:pic_items];
    }
    else if (indexPath.section == 1)
    {
        NSDictionary * tmpDict = array[0];
        NSArray * group = tmpDict[@"group"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"HotTopicTableViewCell.h" forIndexPath:indexPath];
        HotTopicTableViewCell * hotCell = (HotTopicTableViewCell *)cell;
        [hotCell setHotTopicDict:group];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell" forIndexPath:indexPath];
        
        if (_models)
        {
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
        return _height;
    }
    else if (indexPath.section == 1)
    {
        return 80;
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
    //    _block(indexPath.row);
}

@end
