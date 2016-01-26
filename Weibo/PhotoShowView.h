//
//  PhotoShowView.h
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/24.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellDidSelectedBlock)(NSInteger row,UIImage * image,NSUInteger countOfImages);
@class AlbumModel;
@interface PhotoShowView : UIView

-(void)setModels:(AlbumModel *)model;
-(void)setCellDidSelectedBlock:(CellDidSelectedBlock)block;
@end
