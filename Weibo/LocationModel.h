//
//  LocationModel.h
//  JustForFunOfLee
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject

@property (nonatomic,strong)NSString * poi_street_address;

@property (nonatomic,strong)NSString * district_name;

@property (nonatomic,assign)NSInteger checkin_user_num;

@property (nonatomic,strong)NSString * address;

@property (nonatomic,strong)NSString * title;

@property (nonatomic,assign)float lon;

@property (nonatomic,assign)float lat;

@end
