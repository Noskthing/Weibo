//
//  AlbumModel.h
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/23.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AlbumModel : NSObject

//相册名称
@property(nonatomic,copy)NSString * albumName;
//相册封面
@property (nonatomic,strong)UIImage * albumImage;
//相册照片数量
@property (nonatomic,copy)NSString * albumNum;
//相册属性
@property (nonatomic,strong)PHFetchResult * result;

@end
