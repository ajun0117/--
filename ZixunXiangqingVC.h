//
//  ZixunXiangqingVC.h
//  万网
//
//  Created by Ibokan on 12-12-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZixunXiangqingVC : UIViewController<UIWebViewDelegate>
@property(retain,nonatomic)UIWebView *webV;
@property(retain,nonatomic)UILabel *titleL;
@property(retain,nonatomic)NSString *numStr;
@property(retain,nonatomic)NSString *urlS;
@property(retain,nonatomic)NSString *contentStr;
-(void)loadData:(NSString *)nid;
-(NSString *)timestamp;
-(void)jiazaiMore:(NSDictionary *)params;

@end
