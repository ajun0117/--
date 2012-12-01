//
//  TijianVC.h
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TijianVC : UIViewController<UITextFieldDelegate>
@property(retain,nonatomic)UITextField *searTextF;
@property(retain,nonatomic)UILabel *countL;
@property(retain,nonatomic)NSString *tokenStr;
@property(retain,nonatomic)NSDictionary *dic;//domainname字典
-(NSString *)timestamp;
-(void)wwwJiancha;

@end
