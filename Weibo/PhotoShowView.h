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
typedef void(^SelectedBtnDidSelectedBlock)(UIImage * image,BOOL isSelected);
@interface PhotoShowView : UIView

-(void)setModel:(AlbumModel *)model;
-(void)setCellDidSelectedBlock:(CellDidSelectedBlock)block;
-(void)setSelectedBtnDidSelectedBlock:(SelectedBtnDidSelectedBlock)block;
@end
