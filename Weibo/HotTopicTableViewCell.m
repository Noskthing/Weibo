//
//  HotTopicTableViewCell.m
//  Weibo
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "HotTopicTableViewCell.h"

@interface HotTopicTableViewCell ()
{
    IBOutlet UILabel *pne;
    IBOutlet UILabel *two;
    IBOutlet UILabel *three;
    IBOutlet UILabel *four;
    
}
@end
@implementation HotTopicTableViewCell

-(void)setHotTopicDict:(NSArray *)arr
{
    pne.text = arr[0][@"title_sub"];
    two.text = arr[1][@"title_sub"];
    three.text = arr[2][@"title_sub"];
    four.text = arr[3][@"title_sub"];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
