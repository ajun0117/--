//
//  HouzhuiListVC.h
//  万网
//
//  Created by Ibokan on 12-11-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouzhuiListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isAllSelected;
    
}
@property(retain,nonatomic)UITableView *listTableView;
@property(retain,nonatomic)NSMutableArray *listArray;
//@property(retain,nonatomic)NSArray *chinaArray;
@property(retain,nonatomic)NSMutableDictionary *zhuangtaiDic;
@property(assign,nonatomic)BOOL isChina;//判定是否显示中文后缀

@end
