//
//  UIView+Additions.h
//  Additions
//
//  Created by Johnil on 13-6-7.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchBlock)(UITouch *t, UIView *target);

@interface UIView (Additions)
- (float)x;
- (float)y;
- (float)width;
- (float)height;

- (void)setX:(float)x;
- (void)setY:(float)y;
- (void)setWidth:(float)w;
- (void)setHeight:(float)h;

- (float)boundsWidth;
- (float)boundsHeight;
- (void)setBoundsWidth:(float)w;
- (void)setBoundsHeight:(float)h;
//
//- (void)fadeIn;
//- (void)fadeOut;
//- (void)fadeInOnComplet:(void(^)(BOOL f))complet;
//- (void)fadeOutOnComplet:(void(^)(BOOL f))complet;
//
//- (void)removeAllSubviews;
//- (void)removeSubviewWithTag:(NSInteger)tag;
//- (void)removeSubviewExceptTag:(NSInteger)tag;
//- (void)removeSubviewExceptClass:(Class)class1;
//
//- (UIImage *)toAlphaRetinaImageRealTime;
//- (UIImage *)toRetinaImage;
//- (UIImage *)toAlphaRetinaImage;
//- (UIImage *)toImage;
//- (UIImage *)toImagewhithAlpha:(BOOL)alpha;
//- (UIImage *)toImageWithRect:(CGRect)frame;
//- (UIImage *)toImageWithRect:(CGRect)frame withAlpha:(BOOL)alpha;
//- (UIImage *)visbleToImage;
//
//- (void)addWhiteView;
//- (void)addWhiteViewWithAlpha:(float)alpha;
//- (void)addBlackView;
//- (void)addShadowWithColor:(UIColor *)color;
//- (void)addShadow;
//- (void)addShadowWithAlpha:(float)alpha;
//- (void)removeShadow;
//- (UIView *)findAndResignFirstResponder;
//- (void)addBorder;
//- (UIView *)addLine:(UIColor *)color frame:(CGRect)frame;
//
//- (void)addCorner;
//- (void)shake:(float)range;
//- (void)shakeRepeat:(float)range;
//- (void)shakeX:(float)range;
//- (void)rasterize;
//
//+ (void)vveboAnimations:(void (^)(void))animations;
//+ (void)vveboAnimations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
//
//+ (void)vveboAnimateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations;
//+ (void)vveboAnimateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
//+ (void)vveboAnimateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
//+ (void)vveboAnimateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
//
//- (void)addLine:(CGRect)rect;
//- (BOOL)hasActionSheetOrAlert;
//- (UIView *)subviewWithTag:(NSInteger)tag;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com