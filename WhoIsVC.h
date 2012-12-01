//
//  WhoIsVC.h
//  万网
//
//  Created by Ibokan on 12-11-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhoIsVC : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate>
@property(retain,nonatomic)NSString *nameStr;
@property(retain,nonatomic)UITableView *resultTableView;
@property(retain,nonatomic)NSDictionary *resultDic;
@property(retain,nonatomic)NSMutableData *receiveData;
@property(retain,nonatomic)UIButton *xiangBtn;
@property(retain,nonatomic)NSMutableArray *picArray;
@property(retain,nonatomic)NSMutableArray *XinxiArray;
@property(retain,nonatomic)NSMutableArray *nameArray;
@property(retain,nonatomic)UITableView *wZTableView;
@property(retain,nonatomic)NSString *wzStr;
-(void)searWhoIs;
-(NSString *)timestamp;
@end
