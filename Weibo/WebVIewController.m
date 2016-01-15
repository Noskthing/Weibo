//
//  WebVIewController.m
//  Weibo
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "WebVIewController.h"
#import "UIView+Additions.h"

@interface WebVIewController ()<UIWebViewDelegate>
{
    
}
@end

@implementation WebVIewController

#pragma mark   -操作隐去tabbr及上面自定义控件
-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]])
        {
            obj.hidden = YES;
        }
    }];
    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationItem.title = @"加载中...";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]])
        {
            obj.hidden = NO;
        }
    }];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark  -创建UIWebView
-(void)setUrl:(NSString *)url
{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height + 49)];
    [self.view addSubview:webView];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark  -UIWebView代理
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
@end
