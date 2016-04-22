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
typedef BOOL(^SelectedBtnDidSelectedBlock)(UIImage * image,BOOL isSelected,NSInteger num);
@interface PhotoCollectionViewCell : UICollectionViewCell

-(void)setModel:(UIImage *)image isFirstBtn:(BOOL)first;
-(void)setIsSelected:(BOOL)isSelected;
-(void)changeBtnSelected;
-(void)setPhototNumber:(NSInteger)num photosCount:(NSInteger)count AlbumModel:(AlbumModel *)model;
-(void)setCellDidSelectedBlock:(CellDidSelectedBlock)cellBlock SelectedBtnDidSelectedBlock:(SelectedBtnDidSelectedBlock)seleBlock;
@end
