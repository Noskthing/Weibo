//
//  ShareRangeViewController.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/19.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "ShareRangeViewController.h"

@interface ShareRangeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _titles;
    NSArray * _details;
}
@end

@implementation ShareRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titles = @[@"公开",@"好友圈",@"仅自己可见"];
    _details = @[@"所有人可见",@"相互关注好友可见",@""];
    
    [self createNavigationBar];
    [self createUI];
    
}

#pragma mark  -创建导航UI
-(void)createNavigationBar
{
    //背景
    UIView * navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
    navigationView.layer.borderColor = [UIColor colorWithRed:0.843f green:0.843f blue:0.843f alpha:1.00f].CGColor;
    navigationView.layer.borderWidth = 1;
    [self.view addSubview:navigationView];
    
    //取消button
    UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 34, 40, 18)];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0.220f green:0.220f blue:0.220f alpha:1.00f] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn addTarget:self action:@selector(cancelBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navigationView addSubview:cancelBtn];
    
    //发微博标题
    UILabel * locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 36)];
    locationLabel.text = @"选择分享范围";
    locationLabel.font = [UIFont systemFontOfSize:17];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.layer.anchorPoint = CGPointMake(0.5, 0);
    locationLabel.layer.position = CGPointMake(self.view.frame.size.width/2 , 25);
    [navigationView addSubview:locationLabel];
}

#pragma mark  -创建UI
-(void)createUI
{
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 60;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

#pragma mark   -UIButton点击事件
- (void)cancelBtnTouch:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark  -tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShareRangeViewController.h"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ShareRangeViewController.h"];
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, cell.frame.size.width, 0.5)];
        view.backgroundColor = [UIColor colorWithRed:0.957f green:0.957f blue:0.957f alpha:1.00f];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.789f green:0.789f blue:0.789f alpha:1.00f];
        [cell addSubview:view];
    }
    
    if (indexPath.section == 0)
    {
        //标题
        cell.textLabel.text = _titles[indexPath.row];
        //详细描述文字
        if (indexPath.row != 2)
        {
            cell.detailTextLabel.text = _details[indexPath.row];
        }
        //图片
        if (indexPath.row == _num)
        {
            cell.imageView.image = [UIImage imageNamed:@"compose_photo_preview_right"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"compose_photo_preview_default"];
        }
    }
    else
    {
        cell.textLabel.text = @"选择好友";
        cell.imageView.image = [UIImage imageNamed:@"compose_new_group"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 40;
    }
    else
    {
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UILabel * label = [[UILabel alloc] init];
        label.text = @"  指定部分好友可见";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithRed:0.789f green:0.789f blue:0.789f alpha:1.00f];
        label.backgroundColor = [UIColor colorWithRed:0.957f green:0.957f blue:0.957f alpha:1.00f];
        return label;
    }
    else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jurisdiction" object:@(indexPath.row)];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
