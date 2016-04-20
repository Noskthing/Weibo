//
//  CheckPhotoViewCell.h
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/4/20.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^CellDidSelectedBlock)();
@interface CheckPhotoViewCell : UICollectionViewCell

- (void)configWith:(PHAsset*)phasset;
-(void)setCellDidSelectedBlock:(CellDidSelectedBlock)block;
@end
