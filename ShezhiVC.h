//
//  ShezhiVC.h
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShezhiVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)UITableView *myTableView;
@property(retain,nonatomic)NSArray *array;

@end
