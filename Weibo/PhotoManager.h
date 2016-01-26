//
//  PhotoManager.h
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/23.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotoManager : NSObject

+(instancetype)standPhotoManager;

-(NSArray *)getAlbummodels;
-(NSArray *)getPhotoAssets:(PHFetchResult *)fetchResult targetSize:(CGSize)size;
@end
