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

#pragma mark    单例类
+(instancetype)standPhotoManager
{
    static dispatch_once_t onceTokenOfPhtotManger;
    
    static PhotoManager * manager = nil;
    dispatch_once(&onceTokenOfPhtotManger, ^{
        manager = [[PhotoManager alloc] init];
    });
    
    return manager;
}

#pragma mark    判定权限
-(BOOL)photoJurisdiction
{
    //相册权限判断
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized)
    {
        //相册权限开启
        return YES;
    }
//    else if(status == PHAuthorizationStatusNotDetermined)
//    {
//        __block BOOL result;
//        //相册进行授权
//        /* * * 第一次安装应用时直接进行这个判断进行授权 * * */
//        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
//            //授权后直接打开照片库
//            if (status == PHAuthorizationStatusAuthorized)
//            {
//                result = YES;
//            }
//            else
//            {
//                result = NO;
//            }
//        }];
//        return result;
//    }
//    else if (status == PHAuthorizationStatusAuthorized)
//    {
//        return YES;
//    }
    else
    {
        return NO;
    }
}

#pragma mark   获取相册模型
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

#pragma mark 根据collection获取相册模型
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
    
    /**
     All Photos:        所有照片
     Bursts:            连拍快照
     Favorites:         收藏
     Selfies:           自拍
     Screenshots:       屏幕快照
     Recently Added:    最近添加
     */
    
    NSString *titleStr = nil;
    if ([collection.localizedTitle isEqualToString:@"All Photos"])
    {
        titleStr = @"所有相片";
    }
    else if ([collection.localizedTitle isEqualToString:@"Bursts"])
    {
        titleStr = @"连拍快照";
    }
    else if ([collection.localizedTitle isEqualToString:@"Favorites"])
    {
        titleStr = @"收藏";
    }
    else if ([collection.localizedTitle isEqualToString:@"Selfies"])
    {
        titleStr = @"自拍";
    }
    else if ([collection.localizedTitle isEqualToString:@"Screenshots"])
    {
        titleStr = @"屏幕快照";
    }
    else if ([collection.localizedTitle isEqualToString:@"Recently Added"])
    {
        titleStr = @"最近添加";
    }
    else if ([collection.localizedTitle isEqualToString:@"Recently Deleted"])
    {
        titleStr = @"最近删除";
    }
    else if ([collection.localizedTitle isEqualToString:@"Camera Roll"])
    {
        titleStr = @"相册交卷";
    }
    else
    {
        titleStr = [NSString stringWithFormat:@"%@",collection.localizedTitle];
    }
    model.albumName = titleStr;
    
    model.albumNum = [NSString stringWithFormat:@"%lu",(unsigned long)group.count];
    
    model.result = [self getFetchResult:collection];
    
    return model;
}

#pragma mark    获取Result
-(PHFetchResult *)getFetchResult:(PHAssetCollection *)assetCollection
{
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    return fetchResult;
}

#pragma mark    获取图片资源
-(NSArray *)getPhotoAssets:(PHFetchResult *)fetchResult targetSize:(CGSize)size
{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (PHAsset *asset in fetchResult)
    {
//        获取屏幕尺寸 转换图片size单位 targetSize使用的是px
//         CGFloat scale = [[UIScreen mainScreen] scale];
        
        //只添加图片类型资源，去除视频类型资源
        //当mediaType == 2时，这个资源则为视频资源
        if (asset.mediaType == 1)
        {
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [dataArray addObject:result];
            }];
        }
    }
    return [dataArray copy];
}



@end
