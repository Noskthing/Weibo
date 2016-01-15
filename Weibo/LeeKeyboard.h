//
//  LeeKeyboard.h
//  JustForFunOfLee
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLeeKeyBorardWillAppear @"hehelaozijiushitiancai"
#define kLeeKeyBoardWillDisappear @"hehelaozizhenshuai"

//键盘高度
static const CGFloat leeKeyBoardHeight = 216;
//键盘弹出时间
static const CGFloat leeKeyBoardAnimationDuration = 0.2;
//表情分类button高度
static const CGFloat leeKeyBoardCatalogueOfEmotionsHeight = 38;
//几个表情分类
static const NSInteger leeKeyBoardNumOfCatalogue = 4;

@interface LeeKeyboard : UIView

@property (nonatomic,strong)UITextView * textView;

+(instancetype)standLeeKeyBoard;
@end
