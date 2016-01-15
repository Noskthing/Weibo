//
//  WeboTypeHeaderView.m
//  Weibo
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "WeboTypeHeaderView.h"
#import "ConnectDelegate.h"
#import "UIImageView+WebCache.h"
@interface WeboTypeHeaderView ()
{
    IBOutlet UILabel *num;
    IBOutlet UIImageView *_icon;
    IBOutlet UILabel *_name;
    IBOutlet UILabel *desc;
}
@end
@implementation WeboTypeHeaderView


+(instancetype)weboView
{
    return [[NSBundle mainBundle] loadNibNamed:@"WeboTypeHeaderView" owner:nil options:nil][0];
}

#pragma mark  -获取用户信息字典
-(void)getUserInfo
{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    NSDictionary * objDict = [defaults objectForKey:@"userInfo"];
    
    _name.text = objDict[@"name"];
    desc.text = [NSString stringWithFormat:@"简介：%@",objDict[@"description"]];
    num.text = [NSString stringWithFormat:@"关注： %@ | 粉丝数： %@ | 微博数： %@ ",objDict[@"friends_count"],objDict[@"followers_count"],objDict[@"statuses_count"]];
    
    
}
@end
