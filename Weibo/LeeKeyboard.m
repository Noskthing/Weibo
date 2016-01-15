//
//  LeeKeyboard.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "LeeKeyboard.h"
#import "UIView+Additions.h"
#import "LeeScrollViewWithArray.h"
#import "EmotionView.h"
#import "PageControlView.h"

@interface LeeKeyboard ()
{
    UIScreen * _screen;
    //表情图标滚动视图
    LeeScrollViewWithArray * _scrollView;
    //页数指示器
    PageControlView * _pageControlView;
}

@end
#define catalogueBtnTag 300
@implementation LeeKeyboard

#pragma mark  -单例
+(instancetype)standLeeKeyBoard
{
    static dispatch_once_t onceToken;
    static LeeKeyboard * leeKeyBorad = nil;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    dispatch_once(&onceToken, ^{
        leeKeyBorad = [[LeeKeyboard alloc] initWithFrame:CGRectMake(0, screenSize.height, screenSize.width, 200)];
        leeKeyBorad.backgroundColor = [UIColor colorWithRed:0.957f green:0.957f blue:0.957f alpha:1.00f];
        leeKeyBorad.clipsToBounds = NO;
    });
    
    return leeKeyBorad;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    //表情分类按钮
    CGFloat catalogueButtonWidth = self.frame.size.width/leeKeyBoardNumOfCatalogue;
    NSArray * titles = @[@"最近",@"默认",@"emoji",@"浪小花"];
    for (int i = 0; i < leeKeyBoardNumOfCatalogue; i ++)
    {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i * catalogueButtonWidth, leeKeyBoardHeight - leeKeyBoardCatalogueOfEmotionsHeight, catalogueButtonWidth + 1, leeKeyBoardCatalogueOfEmotionsHeight)];
        [btn setTitle:titles[i] forState:0];
        btn.tag = catalogueBtnTag + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor colorWithRed:0.737f green:0.737f blue:0.737f alpha:1.00f] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.424f green:0.424f blue:0.424f alpha:1.00f] forState:UIControlStateSelected];
        if (i == 0)
        {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
        btn.backgroundColor = btn.selected?[UIColor colorWithRed:0.631f green:0.631f blue:0.631f alpha:1.00f]:[UIColor colorWithRed:0.929f green:0.929f blue:0.929f alpha:1.00f];
        [btn addTarget:self action:@selector(catalogueBtnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }
    
    //表情视图创建
    //分类表情的页数
//    NSArray * pages = @[@(1),@(6),@(4),@(2)];
    //总共页数
    NSInteger pageCount = 13;
    NSMutableArray * views = [NSMutableArray array];
    for (int i = 0; i < pageCount; i ++)
    {
        //表情视图
        EmotionView * view = [[EmotionView alloc] init];
        [view setEmotionDidSeletcedBlock:^(UIImage *image,NSString * text) {
            if (_textView)
            {
//                NSTextAttachment * textAttachment01 = [[NSTextAttachment alloc] init];
//                //设置图片源
//                textAttachment01.image = image;
//                //设置图片位置和大小
//                //Y值越小图片越向下   （貌似取值效果与正常frame相反）
//                textAttachment01.bounds = CGRectMake(0, -3, 20,18);
//                NSAttributedString * imageString = [NSAttributedString attributedStringWithAttachment:textAttachment01];
//                NSMutableAttributedString * tmpStr = [_textView.attributedText mutableCopy];
//                [tmpStr appendAttributedString:imageString];
                _textView.text = [_textView.text stringByAppendingString:text];
//                _textView.text = [_textView.text substringToIndex:_textView.text.length - 1];
            }
        }];
        view.tag = i * 5;
        [views addObject:view];
    }
    //滚动视图
    _scrollView = [[LeeScrollViewWithArray alloc] initWithFrame:CGRectMake(0, 0,self.width, leeKeyBoardHeight - leeKeyBoardCatalogueOfEmotionsHeight) andArray:views andTimerWithTimeInterval:999];
    _scrollView.clipsToBounds = NO;
    __weak LeeKeyboard * leeKeyBoard = self;
    
    //自定义页数指示器
    PageControlView * pageControlView = [[PageControlView alloc] initWithFrame:CGRectMake(0,leeKeyBoardHeight - leeKeyBoardCatalogueOfEmotionsHeight - 25, self.width, 20)];
    _pageControlView = pageControlView;
    [self addSubview:pageControlView];
    [pageControlView setPageCount:0 andCurrentPage:0];
    
    //滚动视图滚动时底部按钮联动
    [_scrollView setScrollToPageBlock:^(NSInteger page) {
        NSInteger num;
        NSInteger count = 0;
        NSInteger currentPage = 0;
        if (page > 0)
        {
            if (page > 6)
            {
                if (page > 10)
                {
                    //第四组
                    num = 3;
                    count = 2;
                    currentPage = page - 11;
                }
                else
                {
                    //第三组
                    num = 2;
                    count = 4;
                    currentPage = page - 7;
                }
            }
            else
            {
                //第二组
                num = 1;
                count = 6;
                currentPage = page - 1;
            }
        }
        else
        {
            //第一组
            num = 0;
            count = 0;
            page = 0;
        }
        [pageControlView setPageCount:count andCurrentPage:currentPage];
        [leeKeyBoard changeButtonStatus:num];
    }];
    [self addSubview:_scrollView];
}

#pragma mark   -目录按钮点击事件
-(void)catalogueBtnDidSelected:(UIButton *)button
{
    //点击按钮时滚动视图切换
    NSInteger count;
    switch (button.tag - catalogueBtnTag)
    {
        case 0:
        {
            [_scrollView scrollToPage:0];
            count = 0;
        }
            break;
        case 1:
        {
            [_scrollView scrollToPage:1];
            count = 6;
        }
            break;
        case 2:
        {
            [_scrollView scrollToPage:7];
            count = 4;
        }
            break;
        case 3:
        {
            [_scrollView scrollToPage:11];
            count = 2;
        }
            break;
        default:
            break;
    }
    
    [_pageControlView setPageCount:count andCurrentPage:0];
    
    [self changeButtonStatus:button.tag - catalogueBtnTag];
}

#pragma mark   -遍历button变化选中状态
-(void)changeButtonStatus:(NSInteger)num
{
    for (int i = 0; i  < leeKeyBoardNumOfCatalogue;i ++ )
    {
        UIButton * btn = [self viewWithTag:catalogueBtnTag + i];
        if (i == num)
        {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
        btn.backgroundColor = btn.selected?[UIColor colorWithRed:0.631f green:0.631f blue:0.631f alpha:1.00f]:[UIColor colorWithRed:0.929f green:0.929f blue:0.929f alpha:1.00f];
    }
}

@end
