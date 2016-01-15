//
//  MineHeaderTableViewCell.m
//  Weibo
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "MineHeaderTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface MineHeaderTableViewCell ()
{
    IBOutlet UILabel *numOfFans;
    IBOutlet UILabel *numOfGuanzhu;
    IBOutlet UILabel *numOfWeibo;
    IBOutlet UIImageView *icon;
    IBOutlet UILabel *nickName;
    IBOutlet UIButton *lv;
    IBOutlet UILabel *desc;
    
}
@end
@implementation MineHeaderTableViewCell

-(void)reload
{
    //读取数据
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defaults objectForKey:@"userInfo"];

    icon.layer.cornerRadius = icon.frame.size.width/2;
    [icon sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"profile_image_url"]]];
    nickName.text = dict[@"screen_name"];
    NSString * str = dict[@"description"];
    desc.text = [NSString stringWithFormat:@"简介：%@",[str isEqualToString:@""]?@"暂无简介":str];
    numOfWeibo.text = [NSString stringWithFormat:@"%@",dict[@"statuses_count"]];
    numOfGuanzhu.text = [NSString stringWithFormat:@"%@",dict[@"friends_count"]];
    numOfFans.text = [NSString stringWithFormat:@"%@",dict[@"followers_count"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
