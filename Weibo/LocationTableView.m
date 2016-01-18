//
//  LocationTableView.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "LocationTableView.h"
#import "LocationModel.h"

@interface LocationTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _models;
}
@end
@implementation LocationTableView

-(void)setModels:(NSArray *)models
{
    _models = models;
    [self reloadData];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    self.delegate = self;
    self.dataSource = self;
    self.rowHeight = 70;

}

#pragma mark -代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_models)
    {
        return _models.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LocationTableView.h"];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LocationTableView.h"];
    }
    
    if (_models)
    {
        LocationModel * model = _models[indexPath.row];
        
        cell.textLabel.text = model.title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld人去过·%@",(long)model.checkin_user_num,model.address];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationModel * model = _models[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"address" object:@[@(model.lat),@(model.lon),model.title]];
}
@end
