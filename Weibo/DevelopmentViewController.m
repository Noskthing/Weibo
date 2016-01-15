//
//  DevelopmentViewController.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "DevelopmentViewController.h"
#import "ConnectDelegate.h"
#import "DevelopmentTableView.h"
#import "UIView+Additions.h"

@implementation DevelopmentViewController

-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getUserRelationshipFromNetWork];
}

-(void)getUserRelationshipFromNetWork
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * userInfo = [defaults objectForKey:@"userInfo"];

    NSString * url = [NSString stringWithFormat:@"https://api.weibo.com/2/friendships/show.json?access_token=%@&source_screen_name=%@&target_screen_name=leeB0Wen",[defaults objectForKey:@"access_token"],userInfo[@"screen_name"]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ConnectDelegate * connect = [ConnectDelegate standConnectDelegate];
    [connect requestDataFromUrl:url andParseDataBlock:^(id obj) {
        if (obj)
        {
            NSDictionary * relationshipDict = obj;
            NSDictionary * sourceDict = relationshipDict[@"source"];
            
            //被关注
//            NSInteger followed_by = [sourceDict[@"followed_by"] integerValue];
            //关注
            NSInteger following = [sourceDict[@"following"] integerValue];
            [self createUIWithSymbol:following];
            
            NSLog(@"用户关系 = %@",obj);
        }
    }];
}

-(void)createUIWithSymbol:(NSInteger)symbol
{
    DevelopmentTableView * tableView = [[DevelopmentTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 113)];
    tableView.symbol = symbol;
    [self.view addSubview:tableView];
}
@end
