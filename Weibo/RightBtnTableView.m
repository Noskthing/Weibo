//
//  RightBtnTableView.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "RightBtnTableView.h"

@interface RightBtnTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    CellDidSeletcedBlock _block;
}
@end

@implementation RightBtnTableView

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
    self.rowHeight = self.frame.size.height/2;
    
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RightBtnTableView"];
}

#pragma mark  -代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RightBtnTableView" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18 weight:1.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    bgView.image = [UIImage imageNamed:@"popover_noarrow_background"];
    cell.selectedBackgroundView = bgView;
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.imageView.image = [UIImage imageNamed:@"popover_icon_radar"];
            cell.textLabel.text = @"雷达";
        }
            break;
        case 1:
        {
            cell.imageView.image = [UIImage imageNamed:@"popover_icon_qrcode"];
            cell.textLabel.text = @"扫一扫";
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_block)
    {
        _block(indexPath);
    }
}
@end
