//
//  UIImage+Addition.m
//  03-QQ聊天界面
//
//  Created by vera on 15/8/15.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage (Addition)

/**
 *  返回一个拉伸后的图片
 *
 *  @return <#return value description#>
 */
- (UIImage *)resizeImage
{
    //UIImageResizingModeTile, 平铺
    //UIImageResizingModeStretch, 拉伸
    
    /*
     参数1：指定不拉伸的范围
     */
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(self.size.height/2, self.size.width/2, self.size.height/2, self.size.width/2) resizingMode:UIImageResizingModeTile];
}

@end
