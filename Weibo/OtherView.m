//
//  OtherView.m
//  Weibo
//
//  Created by apple on 15/11/30.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "OtherView.h"



@implementation OtherView

-(void)setImage:(UIImage *)image andTitle:(NSString *)title
{
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width *0.7, self.frame.size.width *0.7);
    imageView.layer.position = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    [self addSubview:imageView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.width, self.frame.size.width, self.frame.size.height - self.frame.size.width)];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [self addSubview:label];
   
}




@end
