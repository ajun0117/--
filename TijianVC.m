//
//  TijianVC.m
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TijianVC.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "TJxiangxiVC.h"
#import "SHKActivityIndicator.h"

@implementation TijianVC
//@synthesize zhuangtaiStr,dnsStr;
@synthesize searTextF;
@synthesize countL;
@synthesize tokenStr;
@synthesize dic;
@synthesize que;
@synthesize zhuangtaiMV,dnsMV,fangwenMV;
@synthesize firstL,xiaolianMV;
@synthesize chushiMV;
@synthesize buyBtn,shoucangBtn,jianshiBtn;
@synthesize xiangxiDic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.xiangxiDic=[NSMutableDictionary dictionary];
        count=0;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.que) {
        self.que=[[ASINetworkQueue alloc]init];
    }
    
    UIImageView *bgIM=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test_ground.png"]];
    bgIM.frame=CGRectMake(0, 0, 320, 460);
    [self.view addSubview:bgIM];
    [bgIM release];
    
    UIImageView *topIM=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    topIM.image=[UIImage imageNamed:@"top.png"];
    topIM.userInteractionEnabled=YES;
    [self.view addSubview:topIM];
    [topIM release];
    
    UIButton *fanhuiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fanhuiBtn.frame=CGRectMake(5, 5, 50, 30);
    [fanhuiBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    fanhuiBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [fanhuiBtn setTitle:@"主页" forState:UIControlStateNormal];
    [fanhuiBtn addTarget:self action:@selector(toZhuye) forControlEvents:UIControlEventTouchUpInside];
    [topIM addSubview:fanhuiBtn];
    
    self.searTextF=[[UITextField alloc]initWithFrame:CGRectMake(30, 44+17, 240, 25)];
    searTextF.delegate=self;
    searTextF.keyboardType=UIKeyboardTypeURL;
    searTextF.clearButtonMode=UITextFieldViewModeWhileEditing;//出现清除文字的小叉叉
    [searTextF setBackground:[UIImage imageNamed:@"seachbox.png"]];
    searTextF.placeholder=@"请您输入域名如:taobao.com";
    [self.view addSubview:searTextF];
    [searTextF release];
    
    UIButton *searBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [searBtn setBackgroundImage:[UIImage imageNamed:@"searchbar.png"] forState:UIControlStateNormal];
    [searBtn addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    searBtn.frame=CGRectMake(280, 44+17+2, 20, 20);
    [self.view addSubview:searBtn];
    
    //状态栏
    self.chushiMV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test_pickground.png"]];
    chushiMV.userInteractionEnabled=YES;
    chushiMV.frame=CGRectMake(15, 90, 290, 70);
    [self.view addSubview:chushiMV];
    
    self.xiaolianMV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smile.png"]];
    xiaolianMV.frame=CGRectMake(0, 0, 30, 30);
    xiaolianMV.center=CGPointMake(30, chushiMV.frame.size.height/2);
    [chushiMV addSubview:xiaolianMV];
    
    self.firstL=[[UILabel alloc]initWithFrame:CGRectMake(53, 28, 200, 15)];
    firstL.backgroundColor=[UIColor clearColor];
    firstL.font=[UIFont boldSystemFontOfSize:14];
    firstL.text=@"此域名未被注册。";
    [chushiMV addSubview:firstL];
    
    self.buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame=CGRectMake(235, 10, 40, 25);
    [buyBtn setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"test_button.png"] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(toBuyIt:) forControlEvents:UIControlEventTouchUpInside];
    [chushiMV addSubview:buyBtn];
    
    self.shoucangBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shoucangBtn.frame=CGRectMake(235, 35, 40, 25);
    [shoucangBtn setImage:[UIImage imageNamed:@"keep.png"] forState:UIControlStateNormal];
    [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"test_button.png"] forState:UIControlStateNormal];
    [shoucangBtn addTarget:self action:@selector(toShoucangIt:) forControlEvents:UIControlEventTouchUpInside];
    [chushiMV addSubview:shoucangBtn];
    
    self.jianshiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    jianshiBtn.frame=CGRectMake(235, 20, 40, 25);
    [jianshiBtn setImage:[UIImage imageNamed:@"test_jiankong.png"] forState:UIControlStateNormal];
    [jianshiBtn setBackgroundImage:[UIImage imageNamed:@"test_button.png"] forState:UIControlStateNormal];
    [jianshiBtn addTarget:self action:@selector(toJianshiIt:) forControlEvents:UIControlEventTouchUpInside];
    [chushiMV addSubview:jianshiBtn];
    jianshiBtn.hidden=YES;
    
    //Whois状态栏
    self.zhuangtaiMV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test_graybutton.png"]];
    zhuangtaiMV.userInteractionEnabled=YES;
    zhuangtaiMV.frame=CGRectMake(15, 175, 290, 55);
    [self.view addSubview:zhuangtaiMV];
    
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(235, 12, 40, 25);
    button1.tag=100;
    [button1 setImage:[UIImage imageNamed:@"detailbutton.png"] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"test_button.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(toXiangxi:) forControlEvents:UIControlEventTouchUpInside];
    [zhuangtaiMV addSubview:button1];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(20, 18, 240, 15)];
    label1.textColor=[UIColor grayColor];
    label1.backgroundColor=[UIColor clearColor];
    label1.font=[UIFont boldSystemFontOfSize:15];
    label1.text=@"域名Whois状态";
    [zhuangtaiMV addSubview:label1];
    
    //DNS状态栏
    self.dnsMV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test_graybutton.png"]];
    dnsMV.userInteractionEnabled=YES;
    dnsMV.frame=CGRectMake(15, 235, 290, 55);
    [self.view addSubview:dnsMV];
    
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake(235, 12, 40, 25);
    button2.tag=200;
    [button2 setImage:[UIImage imageNamed:@"detailbutton.png"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"test_button.png"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(toXiangxi:) forControlEvents:UIControlEventTouchUpInside];
    [dnsMV addSubview:button2];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, 18, 240, 15)];
    label2.textColor=[UIColor grayColor];
    label2.backgroundColor=[UIColor clearColor];
    label2.font=[UIFont boldSystemFontOfSize:15];
    label2.text=@"域名DNS是否有效";
    [dnsMV addSubview:label2];
    
    //访问状态栏
    self.fangwenMV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test_graybutton.png"]];
    fangwenMV.userInteractionEnabled=YES;
    fangwenMV.frame=CGRectMake(15, 295, 290, 55);
    [self.view addSubview:fangwenMV];
    
    UIButton *button3=[UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame=CGRectMake(235, 12, 40, 25);
    button3.tag=300;
    [button3 setImage:[UIImage imageNamed:@"detailbutton.png"] forState:UIControlStateNormal];
    [button3 setBackgroundImage:[UIImage imageNamed:@"test_button.png"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(toXiangxi:) forControlEvents:UIControlEventTouchUpInside];
    [fangwenMV addSubview:button3];
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(20, 18, 240, 15)];
    label3.textColor=[UIColor grayColor];
    label3.backgroundColor=[UIColor clearColor];
    label3.font=[UIFont boldSystemFontOfSize:15];
    label3.text=@"域名Http访问是否正常";
    [fangwenMV addSubview:label3];
    
    //未注册数
    UIImageView *countMV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test_graybutton.png"]];
    countMV.userInteractionEnabled=YES;
    countMV.frame=CGRectMake(15, 355, 290, 55);
    [self.view addSubview:countMV];
    
    UIButton *button4=[UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame=CGRectMake(235, 12, 40, 25);
    button4.tag=400;
    [button4 setImage:[UIImage imageNamed:@"detailbutton.png"] forState:UIControlStateNormal];
    [button4 setBackgroundImage:[UIImage imageNamed:@"test_button.png"] forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(toXiangxi:) forControlEvents:UIControlEventTouchUpInside];
    [countMV addSubview:button4];
    
    self.countL=[[UILabel alloc]initWithFrame:CGRectMake(20, 18, 240, 15)];
    countL.textColor=[UIColor grayColor];
    countL.backgroundColor=[UIColor clearColor];
    countL.font=[UIFont boldSystemFontOfSize:15];
    countL.text=@"未注册域名提醒";
    [countMV addSubview:countL];
    
}

-(void)toBuyIt:(UIButton *)sender{
    
}

-(void)toShoucangIt:(UIButton *)sender{
    
}

-(void)toJianshiIt:(UIButton *)sender{
    
}


-(void)toSearch{
    [searTextF resignFirstResponder];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在体检..."];
    [xiangxiDic removeAllObjects];//删除字典中所有元素
    zhuangtaiMV.image=[UIImage imageNamed:@"test_return.png"];
    dnsMV.image=[UIImage imageNamed:@"test_return.png"];
    fangwenMV.image=[UIImage imageNamed:@"test_return.png"];
        
        NSString *encodeStr=[self.searTextF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//进行编码
        self.dic=[NSDictionary dictionaryWithObjectsAndKeys:encodeStr,@"domainname", nil];//这里是domainname 注意！！！
//**************************************************        
        //是否被注册请求
        NSDictionary *chenkD=[NSDictionary dictionaryWithObjectsAndKeys:encodeStr,@"domainnames", nil];//这里是domainnames 注意！！！
        NSString *tokenStr0=[NSString stringWithFormat:@"%@_%@0",TOKEN,[self timestamp]];
        NSDictionary *params0 = [NSDictionary dictionaryWithObjectsAndKeys:
                                chenkD,@"data",
                                @"1.0",@"v",
                                @"checkdomain",@"method",
                                tokenStr0,@"trid",
                                @"ios",@"client",nil];
        NSURL *url0=[NSURL URLWithString:@"http://hiapp.hichina.com/hiapp/json/checkdomain/"];
        ASIFormDataRequest *request0=[ASIFormDataRequest requestWithURL:url0];
        request0.userInfo=[NSDictionary dictionaryWithObject:@"req0" forKey:@"name"];
        [request0 setRequestMethod:@"POST"];
        [request0 setPostValue:params0 forKey:@"req"];
//**************************************************             
        //whois和dns验证请求
        self.tokenStr=[NSString stringWithFormat:@"%@_%@1",TOKEN,[self timestamp]];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                dic,@"data",
                                @"1.0",@"v",
                                @"whois",@"method",
                                tokenStr,@"trid",
                                @"ios",@"client",nil];
        NSURL *url1=[NSURL URLWithString:@"http://hiapp.hichina.com:8080/hiapp/json/whois/"];
        ASIFormDataRequest *request1=[ASIFormDataRequest requestWithURL:url1];
        request1.userInfo=[NSDictionary dictionaryWithObject:@"req1" forKey:@"name"];
        [request1 setRequestMethod:@"POST"];
        [request1 setPostValue:params forKey:@"req"];
//**************************************************             
        //www访问验证请求
        NSString *tokenS=[NSString stringWithFormat:@"%@_%@2",TOKEN,[self timestamp]];
        NSDictionary *wwwparams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   dic,@"data",
                                   @"1.0",@"v",tokenS,@"trid",
                                   @"wwwrecord",@"method",
                                   @"ios",@"client",nil];
        NSURL *url2=[NSURL URLWithString:@"http://hiapp.hichina.com/hiapp/json/wwwrecord/"];
        ASIFormDataRequest *request2=[ASIFormDataRequest requestWithURL:url2];
        request2.userInfo=[NSDictionary dictionaryWithObject:@"req2" forKey:@"name"];
        [request2 setRequestMethod:@"POST"];
        [request2 setPostValue:wwwparams forKey:@"req"];
//**************************************************             
        //未注册域名列表请求
        NSString *tokenS3=[NSString stringWithFormat:@"%@_%@3",TOKEN,[self timestamp]];
        NSDictionary *noDomainNamePams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   dic,@"data",
                                   @"1.0",@"v",tokenS3,@"trid",
                                   @"noDomainName",@"method",
                                   @"ios",@"client",nil];
        NSURL *url3=[NSURL URLWithString:@"http://hiapp.hichina.com:8080/hiapp/json/noDomainName/"];
        ASIFormDataRequest *request3=[ASIFormDataRequest requestWithURL:url3];
        request3.userInfo=[NSDictionary dictionaryWithObject:@"req3" forKey:@"name"];
        [request3 setRequestMethod:@"POST"];
        [request3 setPostValue:noDomainNamePams forKey:@"req"];
        
        [self.que addOperation:request0];
        [self.que addOperation:request1];
        [self.que addOperation:request2];
        [self.que addOperation:request3];
        que.delegate=self;//设置代理
        [que setRequestDidFinishSelector:@selector(finish:)];   //设置队列请求成功方法
        [que setRequestDidFailSelector:@selector(fail:)];
        [self.que go];  //启动请求队列
    
}

-(void)fail:(ASIHTTPRequest *)request{  //传的对象是请求对象
    NSLog(@"%@",[request error]);
}

-(void)finish:(ASIHTTPRequest *)request{
    NSString *name=[request.userInfo objectForKey:@"name"];     //ASIHTTPRequest底层应该实现了线程安全的线程锁
    NSData *data=[request responseData];
      //获得check请求结果
    if ([name isEqualToString:@"req0"]) 
    {
        count++;
        NSString *checkStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *checkDic=[checkStr JSONValue];
//        NSLog(@"checkDic-------------%@",checkDic);
        NSArray *statusArray=[[checkDic objectForKey:@"results"] objectForKey:@"domainnames"];
        NSString *statusStr=[[statusArray objectAtIndex:0] objectForKey:@"status"];
//        NSLog(@"statusStr------------%@",statusStr);
         if ([statusStr intValue]==0) {//如果次域名未被注册
             xiaolianMV.image=[UIImage imageNamed:@"smile.png"];
             buyBtn.hidden=NO;
             shoucangBtn.hidden=NO;
             jianshiBtn.hidden=YES;
            firstL.text=@"恭喜你！此域名未被注册";
        }
            else{
            xiaolianMV.image=[UIImage imageNamed:@"face14.png"];
            firstL.text=@"此域名已注册,体检情况如下:";
            buyBtn.hidden=YES;
            shoucangBtn.hidden=YES;
            jianshiBtn.hidden=NO;
        }
    }
     //获得Whois请求结果
    if ([name isEqualToString:@"req1"]) 
    {
        count++;
        NSString *receiveStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *whoisDic=[receiveStr JSONValue];
//        NSLog(@"whoisdic-------------%@",whoisDic);
        NSDictionary *dicc=[whoisDic objectForKey:@"results"];
        NSDictionary *resultDic=[dicc objectForKey:@"whois"];
        
        NSString *dnsStr=[resultDic objectForKey:@"dnsserver"];//DNS服务器
        NSString *zhuangtaiStr=[resultDic objectForKey:@"domainstatus"];//域名状态
        UILabel *whoisL=[[UILabel alloc]initWithFrame:CGRectMake(20, 40, 200, 15)];
        whoisL.font=[UIFont systemFontOfSize:12];
        [zhuangtaiMV addSubview:whoisL];
        [whoisL release];
            if (![zhuangtaiStr isEqualToString:@""]) {
                whoisL.textColor=[UIColor greenColor];
                whoisL.text=@"Whois状态正常";
            }
            else{
                whoisL.textColor=[UIColor redColor];
                whoisL.text=@"Whois状态异常";
            }
            
            UILabel *dnsL=[[UILabel alloc]initWithFrame:CGRectMake(20, 40, 200, 15)];
            dnsL.font=[UIFont systemFontOfSize:12];
            [dnsMV addSubview:dnsL];
            [dnsL release];
            if (![dnsStr isEqualToString:@""]) {
                dnsL.textColor=[UIColor greenColor];
                dnsL.text=@"DNS状态有效";
            }
            else{
                dnsL.textColor=[UIColor redColor];
                dnsL.text=@"DNS状态无效";
            }
        NSArray *whoisArray=[[resultDic objectForKey:@"domainstatus"] componentsSeparatedByString:@","];
        NSDictionary *whoisDictionary=[NSDictionary dictionaryWithObject:whoisArray forKey:@"域名whois状态如下:"];
        NSArray *dnsArray=[[resultDic objectForKey:@"dnsserver"] componentsSeparatedByString:@","];
        NSDictionary *dnsDictionary=[NSDictionary dictionaryWithObject:dnsArray forKey:@"DNS服务器如下:"];
        [xiangxiDic setObject:whoisDictionary forKey:[NSNumber numberWithInt:100]];//对应whois按钮
        [xiangxiDic setObject:dnsDictionary forKey:[NSNumber numberWithInt:200]];//对应dns按钮
        }
    //获得www访问请求结果
    if ([name isEqualToString:@"req2"]) 
    {
        count++;
        NSString *wwwReceiveStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *wwwDic=[wwwReceiveStr JSONValue];
//        NSLog(@"wwwwwdic-------------%@",wwwDic);
        
        UILabel *wwwL=[[UILabel alloc]initWithFrame:CGRectMake(20, 40, 200, 15)];
        wwwL.font=[UIFont systemFontOfSize:12];
        [fangwenMV addSubview:wwwL];
        [wwwL release];
        NSString *wwwStatusStr=[[wwwDic objectForKey:@"results"] objectForKey:@"wwwstatus"];
            if ([wwwStatusStr intValue]==1) {
                wwwL.textColor=[UIColor redColor];
                wwwL.text=@"Http访问异常";
            }
            else{
                wwwL.textColor=[UIColor greenColor];
                wwwL.text=@"Http访问正常";
                }
        //把数据组成数组
        NSArray *infosA=[[wwwDic objectForKey:@"results"] objectForKey:@"infos"];
        NSMutableDictionary *wwwDictionary=[NSMutableDictionary dictionary];//用来存所有数据
        int n=0;
        for (NSDictionary *dicc in infosA) {
            n++;
            NSArray *array=[NSArray arrayWithObjects:
                [NSString stringWithFormat:@"网站IP：%@",[dicc objectForKey:@"wppip"]],
                [NSString stringWithFormat:@"服务器归属地：%@",[dicc objectForKey:@"server"]],
                [NSString stringWithFormat:@"状态：%@",[dicc objectForKey:@"status"]],
                [NSString stringWithFormat:@"总时间：%@",[dicc objectForKey:@"total_time"]],
                [NSString stringWithFormat:@"解析时间：%@",[dicc objectForKey:@"resolve_time"]],
                [NSString stringWithFormat:@"连接时间：%@",[dicc objectForKey:@"connect_time"]],
                [NSString stringWithFormat:@"下载数据：%@",[dicc objectForKey:@"down_data"]],
                [NSString stringWithFormat:@"下载速度：%@",[dicc objectForKey:@"down_speed"]],nil];
           [wwwDictionary setObject:array forKey:[NSString stringWithFormat:@"域名服务器%d为:",n]];//这里不能用相同的key
        }
        [xiangxiDic setObject:wwwDictionary forKey:[NSNumber numberWithInt:300]];//对应www按钮
    }
      //获得为注册域名数请求结果
    if ([name isEqualToString:@"req3"]) 
    {
        count++;
        NSString *noDomainNameStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *noDomainNameDic=[noDomainNameStr JSONValue];
        NSLog(@"noDomainNameDic-------------%@",noDomainNameDic);
        NSString *numStr=[[noDomainNameDic objectForKey:@"results"] objectForKey:@"notdomain"];
        NSArray *countArray=[numStr componentsSeparatedByString:@","];
            if ([numStr isEqualToString:@""]) {
                countL.text=@"未注册域名数为:0";
                NSDictionary *noDic=[NSDictionary dictionaryWithObject:countArray forKey:@"没有未注册的域名!"];
                [xiangxiDic setObject:noDic forKey:[NSNumber numberWithInt:400]];//对应未注册详细按钮
            }
            else{
            countL.text=[NSString stringWithFormat:@"未注册域名数为:%d",[countArray count]];
            NSDictionary *noDic=[NSDictionary dictionaryWithObject:countArray forKey:@"未注册的域名如下:"];
            [xiangxiDic setObject:noDic forKey:[NSNumber numberWithInt:400]];//对应未注册详细按钮
            }
    }
//    NSLog(@"xiangxiDic-------0000------%@",xiangxiDic);
    NSLog(@"count---------%d",count);
    if (count==4) {
        [[SHKActivityIndicator currentIndicator] hideAfterDelay:0.5];
        count=0;
    }
}

#pragma mark- 请求时间戳
-(NSString *)timestamp{
    NSString *timeStr=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSLog(@"timeStr----%@",timeStr);
    return timeStr;
}


-(void)toXiangxi:(UIButton *)sender{
    TJxiangxiVC *tjXiangVC=[[TJxiangxiVC alloc]init];
    tjXiangVC.navigationController.navigationBarHidden=YES;
    tjXiangVC.listDic=[xiangxiDic objectForKey:[NSNumber numberWithInt:sender.tag]];
    [self.navigationController pushViewController:tjXiangVC animated:YES];
    [tjXiangVC release];
}


-(void)toZhuye{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)dealloc{
//    [zhuangtaiStr release];
//    [dnsStr release];
    [chushiMV release];
    [buyBtn release];
    [shoucangBtn release];
    [jianshiBtn release];
    [xiaolianMV release];
    [firstL release];
    [zhuangtaiMV release];
    [dnsMV release];
    [fangwenMV release];
    [searTextF release];
    [countL release];
    [tokenStr release];
    [dic release];
    [xiangxiDic release];//自动池管理内存，不需要手动release
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
//    zhuangtaiStr=nil;
//    dnsStr=nil;
    chushiMV=nil;
    buyBtn=nil;
    shoucangBtn=nil;
    jianshiBtn=nil;
    xiaolianMV=nil;
    firstL=nil;
    zhuangtaiMV=nil;
    dnsMV=nil;
    fangwenMV=nil;
    searTextF=nil;
    countL=nil;
    tokenStr=nil;
    dic=nil;
    xiangxiDic=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
