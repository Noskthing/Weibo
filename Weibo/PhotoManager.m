//
//  PhotoManager.m
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/23.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PhotoManager.h"
#import "AlbumModel.h"

@implementation PhotoManager

//单例类
+(instancetype)standPhotoManager
{
    static dispatch_once_t onceTokenOfPhtotManger;
    
    static PhotoManager * manager = nil;
    dispatch_once(&onceTokenOfPhtotManger, ^{
        manager = [[PhotoManager alloc] init];
    });
    
    return manager;
}

//判定权限
-(BOOL)photoJurisdiction
{
    //相册权限判断
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied)
    {
        //相册权限未开启
        return NO;
    }
    else if(status == PHAuthorizationStatusNotDetermined)
    {
        __block BOOL result;
        //相册进行授权
        /* * * 第一次安装应用时直接进行这个判断进行授权 * * */
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            //授权后直接打开照片库
            if (status == PHAuthorizationStatusAuthorized)
            {
                result = YES;
            }
            else
            {
                result = NO;
            }
        }];
        return result;
    }
    else if (status == PHAuthorizationStatusAuthorized)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//获取相册模型
-(NSArray *)getAlbummodels
{
    if ([self photoJurisdiction])
    {
        NSMutableArray *albumModels = [NSMutableArray array];
        //获取默认相册
        PHFetchOptions * fetchOptions = [[PHFetchOptions alloc] init];
        PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:fetchOptions];
        PHAssetCollection * assetCollection = [smartAlbumsFetchResult objectAtIndex:0];
        [albumModels addObject:[self getALbumModelFromPHAssetCollection:assetCollection]];
        //获取其他相册
        PHFetchResult *smartAlbumsFetchResult1 = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:fetchOptions];
        for (PHAssetCollection *sub in smartAlbumsFetchResult1)
        {
            [albumModels addObject:[self getALbumModelFromPHAssetCollection:sub]];
        }
        
        return [albumModels copy];
    }
    else
    {
        return nil;
    }
}

//根据collection获取相册模型
-(AlbumModel *)getALbumModelFromPHAssetCollection:(PHAssetCollection *)collection
{
    AlbumModel * model = [[AlbumModel alloc] init];
    
    PHFetchResult *group = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    [[PHImageManager defaultManager] requestImageForAsset:group.lastObject targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result == nil)
        {
            model.albumImage = [UIImage imageNamed:@""];
        }
        else
        {
            model.albumImage = result;
        }
    }];
    
    if ([collection.localizedTitle isEqualToString:@"Camera Roll"])
    {
        model.albumName = @"相机胶卷";
    }
    else
    {
        model.albumName = [NSString stringWithFormat:@"%@",collection.localizedTitle];
    }
    model.albumNum = [NSString stringWithFormat:@"%lu",(unsigned long)group.count];
    
    model.result = [self getFetchResult:collection];
    
    return model;
}


-(PHFetchResult *)getFetchResult:(PHAssetCollection *)assetCollection
{
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    return fetchResult;
}

//获取图片资源
-(NSArray *)getPhotoAssets:(PHFetchResult *)fetchResult targetSize:(CGSize)size
{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (PHAsset *asset in fetchResult)
    {
        //只添加图片类型资源，去除视频类型资源
        //当mediaType == 2时，这个资源则为视频资源
        if (asset.mediaType == 1)
        {
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [dataArray addObject:result];
            }];
        }
    }
    return [dataArray copy];
}



@end
