//
//  ZixunVC.h
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface ZixunVC : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView0;
    EGORefreshTableHeaderView *_refreshHeaderView1;
    EGORefreshTableHeaderView *_refreshHeaderView2;
    EGORefreshTableHeaderView *_refreshHeaderView3;
    EGORefreshTableHeaderView *_refreshHeaderView4;
    BOOL isflage;
    BOOL _reloading;
//    int who;//区分加载每个tableView
}
@property(retain,nonatomic)UITableView *zuixinTableView;
@property(retain,nonatomic)UITableView *hangngyeTableView;
@property(retain,nonatomic)UITableView *yingyongTableView;
@property(retain,nonatomic)UITableView *jiazhiTableView;
@property(retain,nonatomic)UITableView *anquanTableView;
@property(retain,nonatomic)UISegmentedControl *seg;
@property(retain,nonatomic)NSMutableData *receiveData;
@property(retain,nonatomic)NSMutableArray *lineArray;
@property(retain,nonatomic)UIScrollView *myScrollV;
-(NSString *)timestamp;
-(void)jiamiAndQingqiu:(NSDictionary *)params;
-(void)segmentedControl:(UISegmentedControl *)sender;
- (void)reloadTableViewDataSource; 
- (void)doneLoadingTableViewData; 

@end
