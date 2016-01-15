//
//  WeiBoTableView.h
//  Weibo
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiBoTableView : UITableView

@property (nonatomic,strong)id cellDelegate;

-(void)setDataModels:(NSArray *)models;
@end
