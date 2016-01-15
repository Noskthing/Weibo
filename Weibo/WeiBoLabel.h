//
//  WeiBoLabel.h
//  Weibo
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiBoLabel : UIView

//内容
@property (nonatomic, strong) NSString *text;
//字体颜色
@property (nonatomic, strong) UIColor *textColor;
//字体大小
@property (nonatomic, strong) UIFont *font;
//
@property (nonatomic) NSInteger lineSpace;
//字体格式
@property (nonatomic) NSTextAlignment textAlignment;


-(void)drawText;
@end
