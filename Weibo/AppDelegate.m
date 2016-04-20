//
//  AppDelegate.m
//  Weibo
//
//  Created by apple on 15/11/30.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "AppDelegate.h"
#import "IndexViewController.h"
#import "MessageViewController.h"
#import "UnusedViewController.h"
#import "FindViewController.h"
#import "MineViewController.h"
#import "OtherView.h"
#import "ViewController.h"
#import "APService.h"
#import "LeeKeyboard.h"

@interface AppDelegate ()
{
    UIScreen * _screen;
    UITabBarController * _tabbr;
    
    IndexViewController * rootViewController;
}
@end

@interface WBBaseRequest ()
- (void)debugPrint;
@end

@interface WBBaseResponse ()
- (void)debugPrint;
@end

#define kAppKey         @"559071049"
#define kRedirectURI    @"https://api.weibo.com/oauth2/default.html"

@implementation AppDelegate

@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults removeObjectForKey:@"uid"];
    
    [NSThread sleepForTimeInterval:5.0];
    [_window makeKeyAndVisible];
    
    //导航控制器
    UITabBarController * tabbr = [[UITabBarController alloc] init];
    _tabbr = tabbr;
    
    //设置根控制器
    self.window.rootViewController = tabbr;
    
    //首页
    IndexViewController * index = [[IndexViewController alloc] init];
    UINavigationController * indexNav = [[UINavigationController alloc] initWithRootViewController:index];
    
    //消息
    MessageViewController * message = [[MessageViewController alloc] init];
    UINavigationController * messageNav = [[UINavigationController alloc] initWithRootViewController:message];
    
    //无用的
    UnusedViewController * unused = [[UnusedViewController alloc] init];
    UINavigationController * unusedNav = [[UINavigationController alloc] initWithRootViewController:unused];
    
    //发现
    FindViewController * find = [[FindViewController alloc] init];
    UINavigationController * findNav = [[UINavigationController alloc] initWithRootViewController:find];
    
    //我的
    MineViewController * mine = [[MineViewController alloc] init];
    UINavigationController * mineNav = [[UINavigationController alloc] initWithRootViewController:mine];
    
    //顺序不可以动    必须保证tabbr初始化在子viewController之前  这样才可以在子viewController init方法获取到tabbr
    tabbr.viewControllers = @[indexNav,messageNav,unusedNav,findNav,mineNav];
    
    //获取屏幕尺寸
    _screen = [UIScreen mainScreen];
    
    //集成第三方微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    //表情存储本地
    [self setExpressionInLocal];
    
    //注册表情键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leeKeyBoardWillAppear:) name:kLeeKeyBorardWillAppear object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leeKeyBoardWillDisappear) name:kLeeKeyBoardWillDisappear object:nil];
    
    //JPush
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //categories
            [APService
             registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound |
                                                 UIUserNotificationTypeAlert)
             categories:nil];
        } else {
            //categories nil
            [APService
             registerForRemoteNotificationTypes:      (UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#else
             //categories nil
             categories:nil];
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#endif
             // Required
             categories:nil];
        }
    [APService setupWithOption:launchOptions];

    
    return YES;
}

#pragma mark   -JPush
- (void)applicationWillResignActive:(UIApplication *)application {
    //    [APService stopLogPageView:@"aa"];
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    rootViewController.deviceTokenValueLabel.text =
//    [NSString stringWithFormat:@"%@", deviceToken];
//    _tabbr.deviceTokenValueLabel.textColor =
//    [UIColor colorWithRed:0.0 / 255
//                    green:122.0 / 255
//                     blue:255.0 / 255
//                    alpha:1];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteeNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    [rootViewController addNotificationCount];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}



#pragma mark   -第三方微博
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"didReceiveWeiboRequest");
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
        //存入本地
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[response.userInfo objectForKey:@"access_token"] forKey:@"access_token"];
        [defaults setObject:[response.userInfo objectForKey:@"uid"] forKey:@"uid"];
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        
        //获取indexViewController   再判定一次
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:[[IndexViewController alloc] init]];
        nav = (UINavigationController *)_tabbr.viewControllers[0];
        IndexViewController * index = (IndexViewController *)nav.topViewController;
        [index getJurisdiction];
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        NSString *title = NSLocalizedString(@"支付结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if([response isKindOfClass:WBSDKAppRecommendResponse.class])
    {
        NSString *title = NSLocalizedString(@"邀请结果", nil);
        NSString *message = [NSString stringWithFormat:@"accesstoken:\n%@\nresponse.StatusCode: %d\n响应UserInfo数据:%@\n原请求UserInfo数据:%@",[(WBSDKAppRecommendResponse *)response accessToken],(int)response.statusCode,response.userInfo,response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self ];
}



#pragma mark  -字典表情本地存储
-(void)setExpressionInLocal
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defaults objectForKey:@"expression"];
    if (!dict)
    {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Expression.json" ofType:nil];
        NSData * data = [NSData dataWithContentsOfFile:path];
        NSArray * expressionArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSMutableDictionary * models = [NSMutableDictionary dictionary];
        
        [expressionArr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool
            {
                [models setObject:obj[@"url"] forKey:obj[@"value"]];
            }
        }];
        
        [defaults setObject:[models copy] forKey:@"expression"];
    }
}

#pragma mark   -自定义键盘注册方法
-(void)leeKeyBoardWillAppear:(NSNotification *)notification
{
    UITextView * textView = notification.object;
    
    LeeKeyboard * leeKeyBoard = [LeeKeyboard standLeeKeyBoard];
    leeKeyBoard.textView = textView;
//    leeKeyBoard.frame = CGRectMake(0, _screen.bounds.size.height, _screen.bounds.size.width, 200);
    [self.window addSubview:leeKeyBoard];
    [self.window bringSubviewToFront:leeKeyBoard];
    [UIView animateWithDuration:leeKeyBoardAnimationDuration animations:^{
        leeKeyBoard.frame = CGRectMake(0, _screen.bounds.size.height - leeKeyBoardHeight, _screen.bounds.size.width, leeKeyBoardHeight);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)leeKeyBoardWillDisappear
{
    LeeKeyboard * leeKeyBoard = [LeeKeyboard standLeeKeyBoard];
    [UIView animateWithDuration:leeKeyBoardAnimationDuration animations:^{
        leeKeyBoard.frame = CGRectMake(0, _screen.bounds.size.height, _screen.bounds.size.width, leeKeyBoardHeight);
    } completion:^(BOOL finished) {
        [leeKeyBoard removeFromSuperview];
    }];
}
@end
