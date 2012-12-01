//
//  MoreChaxunVC.h
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreChaxunVC : UIViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int lineCount;
    BOOL isChina;
}
@property(retain,nonatomic)UIButton *englishBtn;
@property(retain,nonatomic)UIButton *chinaBtn;
@property(retain,nonatomic)UITextView *searchV;
@property(retain,nonatomic)UILabel *placeL;
@property(retain,nonatomic)NSMutableArray *selectedArray;//选择的后缀列表
@property(retain,nonatomic)NSMutableData *receiveData;
@property(retain,nonatomic)NSMutableArray *resultArray;
@property(retain,nonatomic)UITableView *resultTableView;
//@property(retain,nonatomic)NSMutableArray *lineArray;
-(NSString *)timestamp;
-(void)addTheLine:(CGRect)frame;

@end
