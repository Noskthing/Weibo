//
//  NavgationBarTitleBtn.h
//  JustForFunOfLee
//
//  Created by apple on 15/12/31.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnDidSelectedBlock)();
@interface NavgationBarTitleBtn : UIView

-(instancetype)navgationBarTitleBtn;
-(void)changeTitle:(NSString *)text;
-(void)setBtnDidSelectedBlock:(BtnDidSelectedBlock)block;
@end
