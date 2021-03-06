//
//  PhotoShowView.h
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/24.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlbumModel;
typedef void(^CellDidSelectedBlock)(NSInteger row,AlbumModel * model,NSUInteger countOfImages);
typedef BOOL(^SelectedBtnDidSelectedBlock)(UIImage * image,BOOL isSelected,NSInteger num);
typedef void(^CameraBtnDidSelectedBlock)();
@interface PhotoShowView : UIView


-(void)selectedItemAtIndexPath:(NSIndexPath *)indexPath;
-(void)setModel:(AlbumModel *)model;
-(void)setImagesNum:(NSArray *)imagesNum;
-(void)setCellDidSelectedBlock:(CellDidSelectedBlock)block;
-(void)setSelectedBtnDidSelectedBlock:(SelectedBtnDidSelectedBlock)block;
-(void)setCameraBtnDidSelectedBlock:(CameraBtnDidSelectedBlock)block;
@end
