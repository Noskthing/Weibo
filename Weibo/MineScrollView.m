//
//  MineScrollView.m
//  Weibo
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "MineScrollView.h"
#import "UIImageView+WebCache.h"

@interface MineScrollView ()
{
    IBOutlet UIImageView *_bgView;
    IBOutlet UILabel *_name;
    IBOutlet UIImageView *_fale;
    IBOutlet UILabel *_num;
    IBOutlet UILabel *_desc;
    IBOutlet UIImageView *_icon;
}
@end

static const CGFloat bgViewHeight = 250;
@implementation MineScrollView

+(instancetype)mineScrollView
{
    return [[NSBundle mainBundle] loadNibNamed:@"MineScrollView" owner:nil options:nil][0];
}



-(void)setUserInfoDict:(NSDictionary *)userInfo
{
    //    [_bgView sd_setImageWithURL:[NSURL URLWithString:userInfo[@"cover_image_phone"]]];
    if ([userInfo[@"gender"] isEqualToString:@"m"])
    {
        _fale.image = [UIImage imageNamed:@"list_male"];
    }
    else
    {
        _fale.image = [UIImage imageNamed:@"list_female"];
    }
    [_icon sd_setImageWithURL:[NSURL URLWithString:userInfo[@"profile_image_url"]]];
    
    _name.text = userInfo[@"name"];
    _num.text = [NSString stringWithFormat:@"关注 %@  丨  粉丝 %@",userInfo[@"friends_count"],userInfo[@"followers_count"]];
    NSString * str = userInfo[@"description"];
    _desc.text = [NSString stringWithFormat:@"简介：%@",[str isEqualToString:@""]?@"暂无简介":userInfo[@"description"]];
}

//在autolayout下，会在viewDidAppear之前根据subview的constraint重新计算scrollview的contentsize。 这就是为什么，在viewdidload里面手动设置了contentsize没用。因为在后面，会再重新计算一次，前面手动设置的值会被覆盖掉。
-(void)layoutSubviews
{
    //圆角   大小宽度xib写死65的
    _icon.layer.cornerRadius = 32.5;
    _icon.layer.masksToBounds = YES;
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + bgViewHeight - 64);
    
}

@end
