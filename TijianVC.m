//
//  TijianVC.m
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TijianVC.h"
#import "JSON.h"

@implementation TijianVC
@synthesize searTextF;
@synthesize countL;
@synthesize tokenStr;
@synthesize dic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    UIImageView *zhuangtaiMV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test_graybutton.png"]];
    zhuangtaiMV.userInteractionEnabled=YES;
    zhuangtaiMV.frame=CGRectMake(15, 90, 290, 55);
    [self.view addSubview:zhuangtaiMV];
    
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(220, 15, 40, 20);
    button1.titleLabel.font=[UIFont systemFontOfSize:12];
    [button1 setTitle:@"详细" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"test_button.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(toXiangxi:) forControlEvents:UIControlEventTouchUpInside];
    [zhuangtaiMV addSubview:button1];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(20, 18, 100, 15)];
    label1.backgroundColor=[UIColor clearColor];
    label1.font=[UIFont boldSystemFontOfSize:15];
    label1.text=@"域名状态检查";
    [zhuangtaiMV addSubview:label1];
    

    UIImageView *dnsMV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test_graybutton.png"]];
    dnsMV.userInteractionEnabled=YES;
    dnsMV.frame=CGRectMake(15, 160, 290, 55);
    [self.view addSubview:dnsMV];
    
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake(220, 15, 40, 20);
    button2.titleLabel.font=[UIFont systemFontOfSize:12];
    [button2 setTitle:@"详细" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"test_button.png"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(toXiangxi:) forControlEvents:UIControlEventTouchUpInside];
    [dnsMV addSubview:button2];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, 18, 100, 15)];
    label2.backgroundColor=[UIColor clearColor];
    label2.font=[UIFont boldSystemFontOfSize:15];
    label2.text=@"域名DNS检查";
    [dnsMV addSubview:label2];
    
    
    UIImageView *fangwenMV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test_graybutton.png"]];
    fangwenMV.userInteractionEnabled=YES;
    fangwenMV.frame=CGRectMake(15, 230, 290, 55);
    [self.view addSubview:fangwenMV];
    
    UIButton *button3=[UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame=CGRectMake(220, 15, 40, 20);
    button3.titleLabel.font=[UIFont systemFontOfSize:12];
    [button3 setTitle:@"详细" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 setBackgroundImage:[UIImage imageNamed:@"test_button.png"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(toXiangxi:) forControlEvents:UIControlEventTouchUpInside];
    [fangwenMV addSubview:button3];
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(20, 18, 100, 15)];
    label3.backgroundColor=[UIColor clearColor];
    label3.font=[UIFont boldSystemFontOfSize:15];
    label3.text=@"域名访问检查";
    [fangwenMV addSubview:label3];
    
    
    UIImageView *countMV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test_graybutton.png"]];
    countMV.userInteractionEnabled=YES;
    countMV.frame=CGRectMake(15, 300, 290, 55);
    [self.view addSubview:countMV];
    
    UIButton *button4=[UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame=CGRectMake(220, 15, 40, 20);
    button4.titleLabel.font=[UIFont systemFontOfSize:12];
    [button4 setTitle:@"详细" forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button4 setBackgroundImage:[UIImage imageNamed:@"test_button.png"] forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(toXiangxi:) forControlEvents:UIControlEventTouchUpInside];
    [countMV addSubview:button4];
    
    self.countL=[[UILabel alloc]initWithFrame:CGRectMake(20, 18, 240, 15)];
    countL.backgroundColor=[UIColor clearColor];
    countL.font=[UIFont boldSystemFontOfSize:15];
    countL.text=@"未注册域名提醒";
    [countMV addSubview:countL];
    
}

-(void)toSearch{//开始体检
    
    NSString *encodeStr=[self.searTextF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//进行编码
    self.dic=[NSDictionary dictionaryWithObjectsAndKeys:encodeStr,@"domainname", nil];//这里是domainname 注意！！！
    NSLog(@"dic----%@",dic);
    self.tokenStr=[NSString stringWithFormat:@"%@_%@1",TOKEN,[self timestamp]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            dic,@"data",
                            @"1.0",@"v",
                            @"whois",@"method",
                            tokenStr,@"trid",
                            @"ios",@"client",nil];
    NSURL *url=[NSURL URLWithString:@"http://hiapp.hichina.com:8080/hiapp/json/whois/"];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    NSString *arguments=[NSString stringWithFormat:@"req=%@",params];
    NSLog(@"arguments -----%@",arguments);
    NSData *postData=[arguments dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
   NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [request release];
    
    NSString *receiveStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *whoisDic=[receiveStr JSONValue];
    NSLog(@"dic-------------%@",whoisDic);
    NSString *dnsStr=[dic objectForKey:@"dnsserver"];//DNS服务器
    NSString *zhuangtaiStr=[dic objectForKey:@"domainstatus"];//域名状态

    [self performSelector:@selector(wwwJiancha) withObject:nil afterDelay:1.f];
}

-(void)wwwJiancha{
    
    NSString *tokenS=[NSString stringWithFormat:@"%@_%@1",TOKEN,[self timestamp]];
    NSDictionary *wwwparams = [NSDictionary dictionaryWithObjectsAndKeys:
                               dic,@"data",
                               @"1.0",@"v",tokenS,@"trid",
                               @"wwwrecord",@"method",
                               @"ios",@"client",nil];
    NSURL *wwwUrl=[NSURL URLWithString:@"http://hiapp.hichina.com/hiapp/json/wwwrecord/"];
    NSMutableURLRequest *wwwRequest=[[NSMutableURLRequest alloc]initWithURL:wwwUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [wwwRequest setHTTPMethod:@"POST"];
    NSString *wwwArguments=[NSString stringWithFormat:@"req=%@",wwwparams];
    NSLog(@"wwwwwwarguments -----%@",wwwArguments);
    NSData *wwwPostData=[wwwArguments dataUsingEncoding:NSUTF8StringEncoding];
    [wwwRequest setHTTPBody:wwwPostData];
    NSData *wwwData=[NSURLConnection sendSynchronousRequest:wwwRequest returningResponse:nil error:nil];
    [wwwRequest release];
    NSString *wwwReceiveStr=[[NSString alloc]initWithData:wwwData encoding:NSUTF8StringEncoding];
    NSDictionary *wwwDic=[wwwReceiveStr JSONValue];
    NSLog(@"wwwwwdic-------------%@",wwwDic);
}



#pragma mark- 请求时间戳
-(NSString *)timestamp{
    NSString *timeStr=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSLog(@"timeStr----%@",timeStr);
    return timeStr;
}



-(void)toXiangxi:(UIButton *)sender{
    
}


-(void)toZhuye{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
