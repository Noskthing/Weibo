//
//  MineTableView.h
//  Weibo
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellDidSeletcedBlock)(NSInteger num);
@interface MineTableView : UITableView

-(void)setCellDidSeletcedBlock:(CellDidSeletcedBlock)block;
@end
