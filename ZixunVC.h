//
//  ZixunVC.h
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@interface ZixunVC : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate,UIScrollViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger page0;//最新资讯的页码
    NSInteger page1;//行业资讯的页码
    NSInteger page2;//应用资讯的页码
    NSInteger page3;//价值资讯的页码
    NSInteger page4;//安全资讯的页码
    BOOL isZXfirst;
    BOOL isHYfirst;
    BOOL isYYfirst;
    BOOL isJZfirst;
    BOOL isAQfirst;
}
@property(retain,nonatomic)PullingRefreshTableView *zuixinTableView;
@property(retain,nonatomic)PullingRefreshTableView *hangyeTableView;
@property(retain,nonatomic)PullingRefreshTableView *yingyongTableView;
@property(retain,nonatomic)PullingRefreshTableView *jiazhiTableView;
@property(retain,nonatomic)PullingRefreshTableView *anquanTableView;
@property(retain,nonatomic)UISegmentedControl *seg;
@property(retain,nonatomic)NSMutableData *receiveData;
@property(retain,nonatomic)NSMutableArray *zuixinArray;
@property(retain,nonatomic)NSMutableArray *hangyeArray;
@property(retain,nonatomic)NSMutableArray *yingyongArray;
@property(retain,nonatomic)NSMutableArray *jiazhiArray;
@property(retain,nonatomic)NSMutableArray *anquanArray;
@property(retain,nonatomic)UIScrollView *myScrollV;
-(NSString *)timestamp;
-(void)sendQingqiu:(NSMutableString *)paramsStr;
-(NSMutableString *)jiamiAndpaixu:(NSDictionary *)params;
-(void)segmentedControl:(UISegmentedControl *)sender;
-(void)jiazaiMore:(NSMutableString *)paramsStr;
//-(void)loadData:(NSInteger)page andType:(NSString *)type;
-(NSDictionary *)getTheParamsWithPage:(NSString *)pageStr andType:(NSString *)type;//获取请求参数
-(void)refrash;
//- (void)reloadTableViewDataSource; 
//- (void)doneLoadingTableViewData; 

@end
