//
//  TitleViewHeader.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "TitleViewHeader.h"

@interface TitleViewHeader ()
@property (strong, nonatomic) IBOutlet UITextField *text;

@end
@implementation TitleViewHeader

+(instancetype)titleViewHeader
{
    return [[NSBundle mainBundle] loadNibNamed:@"TitleViewHeader" owner:self options:nil][0];
}


-(void)setTitle:(NSString *)text
{
    _text.text = text;
}
@end
