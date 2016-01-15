//
//  MineTableViewCell.m
//  Weibo
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "MineTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface MineTableViewCell ()
{
    
    IBOutlet UILabel *subTitle;
    IBOutlet UILabel *title;
    IBOutlet UIImageView *icon;
}
@end
@implementation MineTableViewCell

-(void)reloadDataWithDictionary:(NSDictionary *)dict
{
    title.text = dict[@"desc"];
    subTitle.text = dict[@"desc_extr"];
    [icon sd_setImageWithURL:[NSURL URLWithString:dict[@"pic"]]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
