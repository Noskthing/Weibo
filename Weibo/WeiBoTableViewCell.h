//
//  WeiBoTableViewCell.h
//  Weibo
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击富文本的类型
typedef enum : NSUInteger {
    urlText,
    userText,
    userId,
    topicText,
} RichTextType;

@protocol WeiBoCellRichTextDidSeletcedDelegate <NSObject>

-(void)richTextdDidSeletced:(NSString *)string RichTextType:(RichTextType)type;

@end

@class WeiboModel;
@interface WeiBoTableViewCell : UITableViewCell

@property (nonatomic,strong)id<WeiBoCellRichTextDidSeletcedDelegate> delegate;

-(void)setWeiBoModel:(WeiboModel *)model;
@end
