//
//  AppDelegate.h
//  Weibo
//
//  Created by apple on 15/11/30.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
@class SendMessageToWeiboViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate>
{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SendMessageToWeiboViewController *viewController;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

@end

