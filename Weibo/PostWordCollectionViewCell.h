//
//  PostWordCollectionViewCell.h
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/4/22.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^RemoveBtnDidSelectedBlock)(NSIndexPath * indexPath);

typedef void(^ImageBtnDidSelectedBlock)(NSIndexPath * indexPath);
@interface PostWordCollectionViewCell : UICollectionViewCell


@property (nonatomic,copy)RemoveBtnDidSelectedBlock removeBtnDidSelectedBlock;
@property (nonatomic,copy)ImageBtnDidSelectedBlock imageBtnDidSelectedBlock;

@property (nonatomic,assign)NSIndexPath* indexPath;

- (void)configWith:(id)model;
-(void)addPhotoBtn;
@end
