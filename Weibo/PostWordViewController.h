//
//  PostWordViewController.h
//  JustForFunOfLee
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void(^GetAlbumPhotosBlock)(NSMutableArray * photos);
@interface PostWordViewController : BaseViewController

@property(nonatomic,copy)GetAlbumPhotosBlock getAlbumPhotosBlock;
+(instancetype)postWordViewController;
@end
