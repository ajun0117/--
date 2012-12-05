//
//  TijianVC.h
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"

@interface TijianVC : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>
{
        int count;//用于判定请求完成的
}
@property(retain,nonatomic)UIImageView *chushiMV;
@property(retain,nonatomic)UILabel *firstL;
@property(retain,nonatomic)UIImageView *xiaolianMV;
@property(retain,nonatomic)UIButton *buyBtn;
@property(retain,nonatomic)UIButton *shoucangBtn;
@property(retain,nonatomic)UIButton *jianshiBtn;
@property(retain,nonatomic)UIImageView *zhuangtaiMV;
@property(retain,nonatomic)UIImageView *dnsMV;
@property(retain,nonatomic)UIImageView *fangwenMV;
@property(retain,nonatomic)UITextField *searTextF;
@property(retain,nonatomic)UILabel *countL;
@property(retain,nonatomic)NSString *tokenStr;
@property(retain,nonatomic)NSDictionary *dic;//domainname字典
@property(retain,nonatomic)ASINetworkQueue *que;    //请求队列
//@property(retain,nonatomic)NSString *zhuangtaiStr;
//@property(retain,nonatomic)NSString *dnsStr;
@property(retain,nonatomic)NSMutableDictionary *xiangxiDic;
-(NSString *)timestamp;

@end
