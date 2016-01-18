//
//  LocationViewController.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/15.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ConnectDelegate.h"
#import "Define.h"
#import "LocationModel.h"
#import "LocationTableView.h"

@interface LocationViewController ()<CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager * manager;
@property  (nonatomic,assign) CLLocationCoordinate2D  currentLocation;
@end

@implementation LocationViewController

#pragma mark  -懒加载
- (CLLocationManager *)manager
{
    if (_manager == nil) {
        _manager = [[CLLocationManager alloc] init];
        // 异步返回用户当前位置
        _manager.delegate = self;
        // 定位范围
        /*
         kCLLocationAccuracyNearestTenMeters; 10米
         kCLLocationAccuracyHundredMeters; 100米
         kCLLocationAccuracyKilometer; 1000米
         kCLLocationAccuracyThreeKilometers; 3000米
         */
        _manager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        // 定位效果
        _manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            // NSLocationWhenInUseUsageDescription 在使用的时候授权
            // NSLocationAlwaysUsageDescription 永久授权，如果是在后台定位，需要一个明确指示，告诉用户，当前在后台定位，电池将加快消耗
            [_manager requestWhenInUseAuthorization];
        }
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavigationBar];
    [self.manager startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification) name:@"address" object:nil];
}

#pragma mark  -通知
-(void)getNotification
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark  -创建导航UI
-(void)createNavigationBar
{
    //背景
    UIView * navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
    navigationView.layer.borderColor = [UIColor colorWithRed:0.843f green:0.843f blue:0.843f alpha:1.00f].CGColor;
    navigationView.layer.borderWidth = 1;
    [self.view addSubview:navigationView];
    
    //取消button
    UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 34, 40, 18)];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0.220f green:0.220f blue:0.220f alpha:1.00f] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn addTarget:self action:@selector(cancelBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navigationView addSubview:cancelBtn];
    
    //发微博标题
    UILabel * locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 36)];
    locationLabel.text = @"我在这里";
    locationLabel.font = [UIFont systemFontOfSize:18];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.layer.anchorPoint = CGPointMake(0.5, 0);
    locationLabel.layer.position = CGPointMake(self.view.frame.size.width/2 + 5, 25);
    [navigationView addSubview:locationLabel];
    
}

#pragma mark   -UIButton点击事件
- (void)cancelBtnTouch:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray  *)locations
{
    /* (
     "<+22.28468100,+114.15817700> +/- 5.00m (speed -1.00 mps / course -1.00) @ 15/10/8 \U4e2d\U56fd\U6807\U51c6\U65f6\U95f4 \U4e0b\U53483:24:04"
     )*/
    CLLocation * location = locations[0];
    _currentLocation = location.coordinate;
     NSLog(@"lat:%f  long:%f",location.coordinate.latitude,location.coordinate.longitude);
    
    ConnectDelegate * connect = [ConnectDelegate standConnectDelegate];
    [connect requestDataFromUrl:[NSString stringWithFormat:@"https://api.weibo.com/2/place/nearby/pois.json?access_token=%@&lat=%f&long=%f",NSUserDefaultsObjectForKey(@"access_token"),location.coordinate.latitude,location.coordinate.longitude] andParseDataBlock:^(id obj) {
        if (obj)
        {
            NSDictionary * tmpDict = obj;
            NSArray * arr = tmpDict[@"pois"];
            
            NSMutableArray * models = [NSMutableArray array];
            [arr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LocationModel * model = [[LocationModel alloc] init];
                [model setValuesForKeysWithDictionary:obj];
                [models addObject:model];
            }];
            
            LocationTableView * tableView = [[LocationTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
            [self.view addSubview:tableView];
            [tableView setModels:[models copy]];
        }
    }];
    [self.manager stopUpdatingLocation];
    // 切换到用户当前位置
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败:%@",error);
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 50)];
    label.layer.position = self.view.center;
    label.text = @"定位失败";
    [self.view addSubview:label];
}



@end
