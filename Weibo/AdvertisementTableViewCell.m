//
//  AdvertisementTableViewCell.m
//  Weibo
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "AdvertisementTableViewCell.h"
#import "LeeScrollViewWithArray.h"
#import "UIImageView+WebCache.h"
@interface AdvertisementTableViewCell ()
{
    NSArray * _arr;
}
@end
@implementation AdvertisementTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setViewsArray:(NSArray *)arr
{
    if (!_arr)
    {
        NSMutableArray * views = [NSMutableArray array];
        
        [arr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
            @autoreleasepool
            {
                
                NSString * str = obj[@"pic_big"];
                UIImageView * imageView = [[UIImageView alloc] init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
                [views addObject:imageView];
            }
        }];
        
    //arr是根据所有图片创建的UIImageView
    _arr = [views copy];
        
    LeeScrollViewWithArray * scrollView = [[LeeScrollViewWithArray alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) andArray:_arr andTimerWithTimeInterval:4];
    [scrollView setCurrentDidSelectedBlock:^(NSInteger page) {
        
    }];
        
    [self addSubview:scrollView];
    }
}

@end
