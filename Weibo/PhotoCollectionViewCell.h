//
//  PhotoCollectionViewCell.h
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/24.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  AlbumModel;
typedef void(^CellDidSelectedBlock)(NSInteger row,AlbumModel * model,NSUInteger countOfImages);
typedef void(^CameraBtnDidSelectedBlock)();
typedef BOOL(^SelectedBtnDidSelectedBlock)(UIImage * image,BOOL isSelected,NSInteger num);
@interface PhotoCollectionViewCell : UICollectionViewCell
//图片点击执行的block
@property (nonatomic,copy)CellDidSelectedBlock cellBlock;
//选中图片按钮点击执行的block
@property (nonatomic,copy) SelectedBtnDidSelectedBlock seleBlock;
//照相机按钮点击执行的blcok
@property (nonatomic,copy)CameraBtnDidSelectedBlock cameraBlock;
-(void)setModel:(UIImage *)image isFirstBtn:(BOOL)first;
-(void)setIsSelected:(BOOL)isSelected;
-(void)changeBtnSelected;
-(void)setPhototNumber:(NSInteger)num photosCount:(NSInteger)count AlbumModel:(AlbumModel *)model;
-(void)setCameraBtnDidSelectedBlock:(CameraBtnDidSelectedBlock)block;
-(void)setCellDidSelectedBlock:(CellDidSelectedBlock)cellBlock SelectedBtnDidSelectedBlock:(SelectedBtnDidSelectedBlock)seleBlock;
@end
