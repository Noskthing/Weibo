//
//  TitleViewTableView.h
//  JustForFunOfLee
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellDidSeletcedBlock)(NSIndexPath * indexPath);
@interface TitleViewTableView : UITableView

-(void)setCellDidSelectedBlock:(CellDidSeletcedBlock)block;

-(void)setTitles:(NSArray *)titles;
@end
