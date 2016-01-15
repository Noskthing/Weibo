//
//  NavgationBarTitleBtn.m
//  JustForFunOfLee
//
//  Created by apple on 15/12/31.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "NavgationBarTitleBtn.h"

@interface NavgationBarTitleBtn ()
{
    IBOutlet UILabel *title;
    BtnDidSelectedBlock _block;
    IBOutlet UIButton *btn;
}
@end

@implementation NavgationBarTitleBtn


-(instancetype)navgationBarTitleBtn
{
    return [[NSBundle mainBundle] loadNibNamed:@"NavgationBarTitleBtn" owner:self options:nil][0];
}

-(void)changeTitle:(NSString *)text
{
    title.text = text;
}

-(void)setBtnDidSelectedBlock:(BtnDidSelectedBlock)block
{
    _block = block;
}

- (IBAction)btnDidSeletced:(UIButton *)sender
{
    btn.selected = !btn.selected;
    
    if (_block)
    {
        _block();
    }
}
@end
