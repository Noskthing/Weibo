//
//  PostWordCollectionViewCell.h
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/4/22.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PostWordCollectionViewCell : UICollectionViewCell


- (void)configWith:(PHAsset*)phasset;
-(void)addPhotoBtn;
@end
