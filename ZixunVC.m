//
//  ZixunVC.m
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  李俊阳

#import "ZixunVC.h"
#import "MD5.h"
#import "JSON.h"

@implementation ZixunVC
@synthesize zuixinTableView;
@synthesize hangngyeTableView,yingyongTableView,jiazhiTableView,anquanTableView;
@synthesize receiveData;
@synthesize lineArray;
@synthesize myScrollV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.lineArray=[NSMutableArray array];
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
    [fanhuiBtn setTitle:@"主页" forState:UIControlStateNormal];
    [fanhuiBtn addTarget:self action:@selector(toZhuye) forControlEvents:UIControlEventTouchUpInside];
    [topIM addSubview:fanhuiBtn];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.center=topIM.center;
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=UITextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:18];
    label.text=@"域名资讯";
    [topIM addSubview:label];
    [label release];
    
    UISegmentedControl *seg=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"最新",@"行业",@"应用",@"价值",@"安全",nil]];
    seg.segmentedControlStyle=UISegmentedControlStyleBar;//次类型才能实现点击后图片大小完全填充按钮
//    seg.tintColor=[UIColor blackColor];
    seg.frame=CGRectMake(0, 44, 320, 30);
    [seg setBackgroundImage:[UIImage imageNamed:@"按钮.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [seg setBackgroundImage:[UIImage imageNamed:@"按下.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    seg.selectedSegmentIndex=0;
    [seg addTarget:self action:@selector(segmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    [seg release];
    
    self.zuixinTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+30, 320, 460-44-30) style:UITableViewStylePlain];
    zuixinTableView.delegate=self;
    zuixinTableView.dataSource=self;
    [self.view addSubview:zuixinTableView];
    [zuixinTableView release];
    
    self.hangngyeTableView=[[UITableView alloc]initWithFrame:CGRectMake(320, 44+30, 320, 460-44-30) style:UITableViewStylePlain];
    hangngyeTableView.delegate=self;
    hangngyeTableView.dataSource=self;
    [self.view addSubview:hangngyeTableView];
    [hangngyeTableView release];
    
    self.yingyongTableView=[[UITableView alloc]initWithFrame:CGRectMake(320*2, 44+30, 320, 460-44-30) style:UITableViewStylePlain];
    yingyongTableView.delegate=self;
    yingyongTableView.dataSource=self;
    [self.view addSubview:yingyongTableView];
    [yingyongTableView release];
    
    self.jiazhiTableView=[[UITableView alloc]initWithFrame:CGRectMake(320*3, 44+30, 320, 460-44-30) style:UITableViewStylePlain];
    jiazhiTableView.delegate=self;
    jiazhiTableView.dataSource=self;
    [self.view addSubview:jiazhiTableView];
    [jiazhiTableView release];
    
    self.anquanTableView=[[UITableView alloc]initWithFrame:CGRectMake(320*4, 44+30, 320, 460-44-30) style:UITableViewStylePlain];
    anquanTableView.delegate=self;
    anquanTableView.dataSource=self;
    [self.view addSubview:anquanTableView];
    [anquanTableView release];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"1.0",@"ver",
                            @"ios",@"client",
                            @"list",@"method",
                            @"news",@"module",
                            @"updated",@"type",
                            @"1",@"pageIndex",
                            @"20",@"pageSize",
                            [self timestamp],@"timestamp",
                            @"hello",@"appid",
                            @"111111",@"appkey",nil];
    [self jiamiAndQingqiu:params];
    
}

-(void)jiamiAndQingqiu:(NSDictionary *)params//用于加密并且发起请求
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
    //将做好的字符串进⾏行MD5加密 
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
    [NSURLConnection connectionWithRequest:request delegate:self];
}


-(void)segmentedControl:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:{
            //请求最新资讯
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"1.0",@"ver",
                                    @"ios",@"client",
                                    @"list",@"method",
                                    @"news",@"module",
                                    @"updated",@"type",
                                    @"1",@"pageIndex",
                                    @"20",@"pageSize",
                                    [self timestamp],@"timestamp",
                                    @"hello",@"appid",
                                    @"111111",@"appkey",nil];
            [self jiamiAndQingqiu:params];
            break;
        }
        case 1:{
            //请求行业资讯
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"1.0",@"ver",
                                    @"ios",@"client",
                                    @"list",@"method",
                                    @"news",@"module",
                                    @"industry",@"type",
                                    @"1",@"pageIndex",
                                    @"20",@"pageSize",
                                    [self timestamp],@"timestamp",
                                    @"hello",@"appid",
                                    @"111111",@"appkey",nil];
            [self jiamiAndQingqiu:params];
            break;
        }
        case 2:{
            //请求应用资讯
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"1.0",@"ver",
                                    @"ios",@"client",
                                    @"list",@"method",
                                    @"news",@"module",
                                    @"application",@"type",
                                    @"1",@"pageIndex",
                                    @"20",@"pageSize",
                                    [self timestamp],@"timestamp",
                                    @"hello",@"appid",
                                    @"111111",@"appkey",nil];
            [self jiamiAndQingqiu:params];
            break;
        }
        case 3:{
            //请求价值资讯
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"1.0",@"ver",
                                    @"ios",@"client",
                                    @"list",@"method",
                                    @"news",@"module",
                                    @"value",@"type",
                                    @"1",@"pageIndex",
                                    @"20",@"pageSize",
                                    [self timestamp],@"timestamp",
                                    @"hello",@"appid",
                                    @"111111",@"appkey",nil];
            [self jiamiAndQingqiu:params];
            break;
        } 
        case 4:{
            //请求安全资讯
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"1.0",@"ver",
                                    @"ios",@"client",
                                    @"list",@"method",
                                    @"news",@"module",
                                    @"security",@"type",
                                    @"1",@"pageIndex",
                                    @"20",@"pageSize",
                                    [self timestamp],@"timestamp",
                                    @"hello",@"appid",
                                    @"111111",@"appkey",nil];
            [self jiamiAndQingqiu:params];
            break;
        }
        default:
            break;
    }
}

-(NSString *)timestamp{
    NSString *timeStr=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceNow]];
    return timeStr;
}

//以下为connection的代理⽅方法
#pragma mark - 关于资讯的单独⺴⽹网络请求 ----开始----
- (void)connection:(NSURLConnection *)connection didReceiveResponse: (NSURLResponse *)response
{
    self.receiveData = [NSMutableData data];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableString *receiveStr = [[NSMutableString alloc]
                                   initWithData:self.receiveData encoding:NSUTF8StringEncoding];
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
    [lineArray removeAllObjects];
    [lineArray addObjectsFromArray:[dic objectForKey:@"list"]];
    [zuixinTableView reloadData];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError
                                                                   *)error
{
    NSLog(@"%@",[error debugDescription]);
}
#pragma mark - 关于资讯的单独⺴⽹网络请求 ----结束----

                                
#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [lineArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ind=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ind];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ind];
        UIImageView *cellBG=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"横条2.png"]];
        cellBG.frame=CGRectMake(0, 0, 320, 70);
        [cell addSubview:cellBG];
        [cellBG release];
        UIImageView *wenjianIM=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"文件.png"]];
        wenjianIM.frame=CGRectMake(10, 0, 20, 20);
        wenjianIM.center=CGPointMake(10, cell.frame.size.height/2);//将文件图标放在左中位置
        [cellBG addSubview:wenjianIM];
        [wenjianIM release];
        
        UILabel *myTextLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 5, 260, 20)];
        myTextLabel.backgroundColor=[UIColor clearColor];
        myTextLabel.font=[UIFont systemFontOfSize:15];
        myTextLabel.tag=200;
        [cellBG addSubview:myTextLabel];
        [myTextLabel release];
        
        UILabel *myDetailTextLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 30)];
        myDetailTextLabel.backgroundColor=[UIColor clearColor];
        myDetailTextLabel.font=[UIFont systemFontOfSize:10];
        myDetailTextLabel.tag=300;
        myDetailTextLabel.numberOfLines=2;
        myDetailTextLabel.lineBreakMode=UILineBreakModeWordWrap;
        [cellBG addSubview:myDetailTextLabel];
        [myDetailTextLabel release];
        
        UILabel *timeL=[[UILabel alloc]initWithFrame:CGRectMake(220, 55, 60, 12)];
        timeL.backgroundColor=[UIColor clearColor];
        timeL.tag=100;
        timeL.font=[UIFont systemFontOfSize:10];
        [cell addSubview:timeL];
        [timeL release];
    }
    NSDictionary *dic=[lineArray objectAtIndex:indexPath.row];
    UILabel *myTextLabel=(UILabel *)[cell viewWithTag:200];
    myTextLabel.text=[dic objectForKey:@"title"];
    UILabel *myDetailTextLabel=(UILabel *)[cell viewWithTag:300];
    myDetailTextLabel.text=[dic objectForKey:@"description"];
    UILabel *timeL=(UILabel *)[cell viewWithTag:100];
    timeL.text=[dic objectForKey:@"date"];
    return cell;
}

-(void)toZhuye{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)dealloc
{
    [zuixinTableView release];
    [hangngyeTableView release];
    [yingyongTableView release];
    [jiazhiTableView release];
    [anquanTableView release];
    //    [chinaArray release];
    [super dealloc];
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
