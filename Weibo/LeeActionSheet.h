//
//  LeeActionSheet.h
//  JustForFunOfLee
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LeeActionSheetDidSelectedBlock)(NSInteger num);
@interface LeeActionSheet : UITableView

-(instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles leeActionSheetDidSelectedBlock:(LeeActionSheetDidSelectedBlock)block;
-(void)show;
@end
