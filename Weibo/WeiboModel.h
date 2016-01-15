//
//  WeiboModel.h
//  Weibo
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WeiboModel : NSObject

//微博内容
@property (nonatomic,copy)NSString * text;
//微博来源
@property (nonatomic,copy)NSString * source;
//创建时间
@property (nonatomic,copy)NSString * created_at;
//转发数
@property (nonatomic,assign)NSInteger reposts_count;
//评论数
@property (nonatomic,assign)NSInteger comments_count;
//点赞数
@property (nonatomic,assign)NSInteger attitudes_count;
//用户
@property (nonatomic,strong)NSDictionary * user;
//转发微博
@property (nonatomic,strong)NSDictionary * retweeted_status;
//图片数目
@property (nonatomic,strong)NSArray * pic_urls;
//图片数目
@property (nonatomic,strong)NSArray * retweeted_pic_urls;
//cell大小
@property (nonatomic,assign)CGFloat cellHeight;
//微博内容size
@property (nonatomic,assign)CGSize textSize;
//转发内容size
@property (nonatomic,assign)CGSize repostSize;
//图片size
@property (nonatomic,assign)CGSize picturlsSize;
//转发实际内容
@property (nonatomic,copy)NSString * retweeted_string;
//转发实际内容富文本
@property (nonatomic,copy)NSMutableAttributedString * retweeted_attributedString;
//微博内容富文本
@property (nonatomic,copy)NSMutableAttributedString * attributedString;


-(void)getCellHeightWithContent;
@end
