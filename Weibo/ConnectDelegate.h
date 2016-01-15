//
//  ConnectDelegate.h
//  Weibo
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^ParseDataBlock)(id obj);
@interface ConnectDelegate : NSObject

+(instancetype)standConnectDelegate;
-(void)requestDataFromUrl:(NSString *)url andParseDataBlock:(ParseDataBlock)block;
-(void)requestDataFromUrl:(NSString *)url parameters:(id)parameters andParseDataBlock:(ParseDataBlock)block;
@end
