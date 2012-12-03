//
//  TJxiangxiVC.h
//  万网
//
//  Created by Ibokan on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJxiangxiVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)UITableView *listTableView;
//@property(retain,nonatomic)UILabel *titleL;
@property(retain,nonatomic)NSDictionary *listDic;
@end
