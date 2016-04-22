//
//  NavTitleView.m
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/4/22.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "NavTitleView.h"

@implementation NavTitleView


+(instancetype)navTitleView
{
    return [[NSBundle mainBundle] loadNibNamed:@"NavTitleView" owner:nil options:nil][0];
}
@end
