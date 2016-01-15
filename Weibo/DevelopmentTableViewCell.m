//
//  DevelopmentTableViewCell.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "DevelopmentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ConnectDelegate.h"
#import "Define.h"

@interface DevelopmentTableViewCell ()
{
    
    IBOutlet UIImageView *icon;
    IBOutlet UILabel *nickName;
    IBOutlet UILabel *detail;
    IBOutlet UILabel *newWeibo;
    IBOutlet UIButton *btn;
    IBOutlet UIImageView *follwowImg;
    IBOutlet UILabel *followLabel;
}
@end

@implementation DevelopmentTableViewCell

- (void)awakeFromNib
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //拼接url
    NSString * url = [NSString stringWithFormat:@"%@?access_token=%@&screen_name=leeB0Wen",UserInfoUrl,[defaults objectForKey:@"access_token"]];
    //url可能含中文  按UTF8编码处理
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ConnectDelegate * connect = [ConnectDelegate standConnectDelegate];
    [connect requestDataFromUrl:url andParseDataBlock:^(id obj) {
        //个人简介
        NSDictionary * userInfo = obj;
        detail.text = userInfo[@"description"];
        //最近一条微博
        NSDictionary * status = userInfo[@"status"];
        newWeibo.text = status[@"text"];
        //头像
        NSString * str = userInfo[@"profile_image_url"];
        [icon sd_setImageWithURL:[NSURL URLWithString:str]];
    }];
   
    //头像圆角
    icon.layer.cornerRadius = icon.frame.size.width/2;
    icon.clipsToBounds = YES;
}

-(void)setFollowingSymbol:(NSInteger)symbol
{
    switch (symbol)
    {
        case 0:
        {
            followLabel.text = @"未关注";
            followLabel.textColor = [UIColor orangeColor];
            follwowImg.image = [UIImage imageNamed:@"card_icon_addattention"];
        }
            break;
        case 1:
        {
            followLabel.text = @"已关注";
            followLabel.textColor = [UIColor colorWithRed:0.365f green:0.365f blue:0.365f alpha:1.00f];
            follwowImg.image = [UIImage imageNamed:@"card_icon_attention"];
        }
            break;
        default:
            break;
    }
    btn.tag = symbol;
}

- (IBAction)followBtnDidSeletced:(UIButton *)sender
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * access_token = [defaults objectForKey:@"access_token"];
    
    ConnectDelegate * connect = [ConnectDelegate standConnectDelegate];
    
    switch (sender.tag)
    {
        case 0:
        {
            [connect requestDataFromUrl:@"https://api.weibo.com/2/friendships/create.json" parameters:@{@"access_token":access_token,@"screen_name":@"leeB0Wen"} andParseDataBlock:^(id obj) {
                if (obj)
                {
                    NSLog(@"dada");
                }
            }];
            
        }
            break;
        case 1:
        {
            
        }
            break;
        default:
            break;
    }
}

@end
