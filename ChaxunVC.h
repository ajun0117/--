//
//  ChaxunVC.h
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChaxunVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NSURLConnectionDataDelegate>
{
    BOOL isChina;
}
@property(retain,nonatomic)UITextField *searTextF;
@property(retain,nonatomic)UIButton *englishBtn;
@property(retain,nonatomic)UIButton *chinaBtn;
@property(retain,nonatomic)UITableView *listTableView;
@property(retain,nonatomic)NSMutableArray *englishH;
@property(retain,nonatomic)NSMutableArray *chinaH;
@property(retain,nonatomic)NSMutableData *receiveData;
@property(retain,nonatomic)UITableView *resultTableView;
@property(retain,nonatomic)NSMutableArray *resultArray;
-(NSString *)timestamp;
@end
