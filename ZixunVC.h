//
//  ZixunVC.h
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZixunVC : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate,UIScrollViewDelegate>
@property(retain,nonatomic)UITableView *zuixinTableView;
@property(retain,nonatomic)UITableView *hangngyeTableView;
@property(retain,nonatomic)UITableView *yingyongTableView;
@property(retain,nonatomic)UITableView *jiazhiTableView;
@property(retain,nonatomic)UITableView *anquanTableView;
@property(retain,nonatomic)NSMutableData *receiveData;
@property(retain,nonatomic)NSMutableArray *lineArray;
@property(retain,nonatomic)UIScrollView *myScrollV;
+ (NSString *)md5Digest:(NSString *)str;
-(NSString *)timestamp;
-(void)jiamiAndQingqiu:(NSDictionary *)params;

@end
