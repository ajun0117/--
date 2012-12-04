//
//  ZixunXiangqingVC.m
//  万网
//
//  Created by Ibokan on 12-12-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZixunXiangqingVC.h"
#import "MD5.h"
#import "JSON.h"
#import "SHKActivityIndicator.h"

@implementation ZixunXiangqingVC
@synthesize webV;
@synthesize titleL,numStr;
@synthesize urlS,contentStr;

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
    UIImageView *topIM=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    topIM.image=[UIImage imageNamed:@"top.png"];
    topIM.userInteractionEnabled=YES;
    [self.view addSubview:topIM];
    [topIM release];
    
    UIButton *fanhuiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fanhuiBtn.frame=CGRectMake(5, 5, 50, 30);
    [fanhuiBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    fanhuiBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [fanhuiBtn setTitle:@"返回" forState:UIControlStateNormal];
    [fanhuiBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [topIM addSubview:fanhuiBtn];
    
    UIButton *moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame=CGRectMake(265, 5, 50, 30);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"rightbutton.png"] forState:UIControlStateNormal];
    moreBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    [moreBtn setTitle:@"分享" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [topIM addSubview:moreBtn];
    
    self.titleL=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleL.center=topIM.center;
    titleL.backgroundColor=[UIColor clearColor];
    titleL.textColor=[UIColor whiteColor];
    titleL.textAlignment=UITextAlignmentCenter;
    titleL.font=[UIFont boldSystemFontOfSize:18];
    [topIM addSubview:titleL];
    [titleL release];
    
    self.webV=[[UIWebView alloc]initWithFrame:CGRectMake(0, 44, 320, 460-44)];
    webV.delegate=self;
    [self.view addSubview:webV];
    [webV release];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"加载中..."];
    [self loadData:self.numStr];
}

-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)share{
    
}

-(void)loadData:(NSString *)nid{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"1.0",@"ver",
                            @"ios",@"client",
                            @"content",@"method",
                            @"news",@"module",
                            nid,@"newsID",
                            [self timestamp],@"timestamp",
                            @"hello",@"appid",
                            @"111111",@"appkey",nil];
    [self jiazaiMore:params];
}

-(NSString *)timestamp{
    NSString *timeStr=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    return timeStr;
}

-(void)jiazaiMore:(NSDictionary *)params
{
    //参数按⾸首字⺟母排序
    NSArray *array = [[params allKeys]
                      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSLog(@"%@",array);
    //按照参数排序后的顺序,将其对应的value,进⾏字符串拼接
    NSMutableString *signStr = [[NSMutableString alloc] init]; for (int i = 0; i < [array count]; i++) {
        NSString *key = [array objectAtIndex:i]; //从排序好的参数数组中,取得key
        NSString *value = [params valueForKey:key]; //从做好的参数字典中,通过 key,取得对应的value
        [signStr insertString:value atIndex:signStr.length]; //将取出的 value,加到字符串里面
    }
    NSLog(@"%@",signStr);
    //将做好的字符串进行MD5加密 
    NSString *sign = [MD5 md5Digest:signStr];
    //将所有的参数和值进⾏行最后的拼接,使⽤用"&"连接 
    NSArray *keys = [params allKeys]; NSArray *values = [params allValues];
    NSMutableString *paramsStr = [[NSMutableString alloc] init];
    for (int i = 0; i < [keys count]; i++) {
        NSString *key = [keys objectAtIndex:i];
        NSString *value = [values objectAtIndex:i];
        [paramsStr appendString:key];
        [paramsStr appendString:@"="];
        [paramsStr appendString:value];
        [paramsStr appendString:@"&"];
    }
    [paramsStr appendFormat:@"sign=%@",sign];
    NSLog(@"%@",paramsStr);
    NSString *urlStr = [NSString stringWithFormat:@"http://zixun.www.net.cn/api/hichinaapp.php?%@",paramsStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSMutableString *receiveStr = [[NSMutableString alloc]
                                   initWithData:data encoding:NSUTF8StringEncoding];
    NSRange ra;
    ra = [receiveStr rangeOfString:@"{"];
    NSRange delRa;
    delRa.location = 0;
    if (ra.length == 0)
    {
        delRa.length = 0;
    }
    else
    {
        delRa.length = ra.location;
    }
    [receiveStr deleteCharactersInRange:delRa];
    //******修改结束
    //转化成可用字典
    NSDictionary *dic=[receiveStr JSONValue];
    NSLog(@"%@",dic);
    self.urlS=[dic objectForKey:@"url"];
    self.contentStr=[dic objectForKey:@"content"];
    NSURL *url1=[NSURL URLWithString:urlS];
    [webV loadHTMLString:contentStr baseURL:url1];
    [[SHKActivityIndicator currentIndicator] hideAfterDelay:0.5];
}

-(void)dealloc{
    [webV release];
    [titleL release];
    [numStr release];
    [urlS release];
    [contentStr release];
    [super dealloc];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    webV=nil;
    titleL=nil;
    numStr=nil;
    urlS=nil;
    contentStr=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
