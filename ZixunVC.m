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
#import "ZixunXiangqingVC.h"
#import "SHKActivityIndicator.h"

@implementation ZixunVC
@synthesize zuixinTableView;
@synthesize hangyeTableView,yingyongTableView,jiazhiTableView,anquanTableView;
@synthesize receiveData;
@synthesize zuixinArray,hangyeArray,yingyongArray,jiazhiArray,anquanArray;
@synthesize myScrollV;
@synthesize seg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.zuixinArray=[NSMutableArray array];
        self.hangyeArray=[NSMutableArray array];
        self.yingyongArray=[NSMutableArray array];
        self.jiazhiArray=[NSMutableArray array];
        self.anquanArray=[NSMutableArray array];
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
    page0=1;
    page1=1;
    page2=1;
    page3=1;
    page4=1;
    isZXfirst=YES;
    isHYfirst=YES;
    isYYfirst=YES;
    isJZfirst=YES;
    isAQfirst=YES;
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
    
    self.seg=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"最新",@"行业",@"应用",@"价值",@"安全",nil]];
    seg.segmentedControlStyle=UISegmentedControlStyleBar;//此类型实现点击后图片大小完全填充按钮
    seg.frame=CGRectMake(0, 44, 320, 30);
//    [seg setBackgroundImage:[UIImage imageNamed:@"按钮.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [seg setBackgroundImage:[UIImage imageNamed:@"按下.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//    [seg setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor] forState:UIControlStateNormal];
    seg.selectedSegmentIndex=0;
    [seg addTarget:self action:@selector(segmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    [seg release];
    
    self.myScrollV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+30, 320, 460-44-30)];
    myScrollV.delegate=self;
    myScrollV.contentSize=CGSizeMake(320*5, 460-44-30);
    myScrollV.pagingEnabled=YES;
    myScrollV.showsHorizontalScrollIndicator=NO; 
    [self.view addSubview:myScrollV];
    [myScrollV release];
    
    self.zuixinTableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44-30) pullingDelegate:self];
    zuixinTableView.delegate=self;
    zuixinTableView.dataSource=self;
    [myScrollV addSubview:zuixinTableView];
    [zuixinTableView release];
    
    self.hangyeTableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(320, 0, 320, 460-44-30) pullingDelegate:self];
    hangyeTableView.delegate=self;
    hangyeTableView.dataSource=self;
    [myScrollV addSubview:hangyeTableView];
    [hangyeTableView release];
    
    self.yingyongTableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(320*2, 0, 320, 460-44-30) pullingDelegate:self];
    yingyongTableView.delegate=self;
    yingyongTableView.dataSource=self;
    [myScrollV addSubview:yingyongTableView];
    [yingyongTableView release];
    
    self.jiazhiTableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(320*3, 0, 320, 460-44-30) pullingDelegate:self];
    jiazhiTableView.delegate=self;
    jiazhiTableView.dataSource=self;
    [myScrollV addSubview:jiazhiTableView];
    [jiazhiTableView release];
    
    self.anquanTableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(320*4, 0, 320, 460-44-30) pullingDelegate:self];
    anquanTableView.delegate=self;
    anquanTableView.dataSource=self;
    [myScrollV addSubview:anquanTableView];
    [anquanTableView release];
    
//    if (page0==0) {
//        [[SHKActivityIndicator currentIndicator]displayActivity:@"正在请求数据..."];
//        [zuixinTableView launchRefreshing];
//    }
    [self segmentedControl:seg];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%s",__FUNCTION__);
    if (scrollView==myScrollV) {
        int x=scrollView.contentOffset.x;
        switch (x) {
            case 0:{
                seg.selectedSegmentIndex=0;
                break;
            }
            case 320:{
                seg.selectedSegmentIndex=1;
               
                break;
            }
            case 640:{
                seg.selectedSegmentIndex=2;
                
                break;
            }
            case 960:{
                seg.selectedSegmentIndex=3;
                
                break;
            }
            case 1280:{
                seg.selectedSegmentIndex=4;
                
                break;
            }
            default:
                break;
        }
        [self segmentedControl:seg];
    }
}


#pragma mark - Scroll
//会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。  
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==zuixinTableView) {
        [zuixinTableView tableViewDidScroll:scrollView];
    }
    else if(scrollView==hangyeTableView){
        [hangyeTableView tableViewDidScroll:scrollView];
    }
    else if(scrollView==yingyongTableView){
        [yingyongTableView tableViewDidScroll:scrollView];
    }
    else if(scrollView==jiazhiTableView){
        [jiazhiTableView tableViewDidScroll:scrollView];
    }
    else if(scrollView==anquanTableView){
        [anquanTableView tableViewDidScroll:scrollView];
    }
}

//当用户抬起拖动的手指时得到通知。还会得到一个布尔值，知名报告滚动视图最后位置之前，是否需要减速。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView==zuixinTableView) {
        [zuixinTableView tableViewDidEndDragging:scrollView];
    }
    else if(scrollView==hangyeTableView){
       [hangyeTableView tableViewDidEndDragging:scrollView];
    }
    else if(scrollView==yingyongTableView){
       [yingyongTableView tableViewDidEndDragging:scrollView];
    }
    else if(scrollView==jiazhiTableView){
      [jiazhiTableView tableViewDidEndDragging:scrollView];
    }
    else if(scrollView==anquanTableView){
       [anquanTableView tableViewDidEndDragging:scrollView];
    }
}
#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(refrash) withObject:nil afterDelay:1.f];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
     [[SHKActivityIndicator currentIndicator]displayActivity:@"正在加载更多信息..."];
    [self performSelector:@selector(jiazaiGengduo) withObject:nil afterDelay:1.f];
}

-(void)jiazaiGengduo{
    switch (seg.selectedSegmentIndex) {
        case 0:{
            page0++;
//            refreshing=YES;
            NSString *pageStr=[NSString stringWithFormat:@"%d",page0];
            NSDictionary *params=[self getTheParamsWithPage:pageStr andType:@"updated"]; 
            NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
            [self jiazaiMore:paramsStr];
            break;}
            
        case 1:{
            page1++;
//            refreshing=YES;
            NSString *pageStr=[NSString stringWithFormat:@"%d",page1];
            NSDictionary *params=[self getTheParamsWithPage:pageStr andType:@"industry"]; 
            NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
            [self jiazaiMore:paramsStr];
//            [self loadData:page1 andType:@"industry"];  
            break;}
            
        case 2:{
            page2++;
//            refreshing=YES;
            NSString *pageStr=[NSString stringWithFormat:@"%d",page2];
            NSDictionary *params=[self getTheParamsWithPage:pageStr andType:@"application"]; 
            NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
            [self jiazaiMore:paramsStr];
//            [self loadData:page2 andType:@"application"];
            break;}
            
        case 3:{
            page3++;
//            refreshing=YES;
            NSString *pageStr=[NSString stringWithFormat:@"%d",page3];
            NSDictionary *params=[self getTheParamsWithPage:pageStr andType:@"value"]; 
            NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
            [self jiazaiMore:paramsStr];
//            [self loadData:page3 andType:@"value"]; 
            break;}
            
        case 4:{
            page4++;
//            refreshing=YES;
            NSString *pageStr=[NSString stringWithFormat:@"%d",page4];
            NSDictionary *params=[self getTheParamsWithPage:pageStr andType:@"security"]; 
            NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
            [self jiazaiMore:paramsStr];
//            [self loadData:page4 andType:@"security"]; 
            break;}
        default:
            break;
    }
}

-(void)jiazaiMore:(NSMutableString *)paramsStr
{
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
    [receiveStr release];
    NSLog(@"%@",dic);
    [[SHKActivityIndicator currentIndicator]hideAfterDelay:0.5];
    switch (seg.selectedSegmentIndex) {
        case 0:{
            [zuixinArray addObjectsFromArray:[dic objectForKey:@"list"]];
//            refreshing=NO;
            [zuixinTableView tableViewDidFinishedLoading];
            [zuixinTableView reloadData];
            break;}
        case 1:{
            [hangyeArray addObjectsFromArray:[dic objectForKey:@"list"]];
//            refreshing=NO;
            [hangyeTableView tableViewDidFinishedLoading];
            [hangyeTableView reloadData];
            break;}
        case 2:{
//            refreshing=NO;
            [yingyongArray addObjectsFromArray:[dic objectForKey:@"list"]];
            [yingyongTableView tableViewDidFinishedLoading];
            [yingyongTableView reloadData];
            break;}
        case 3:{
//            refreshing=NO;
            [jiazhiArray addObjectsFromArray:[dic objectForKey:@"list"]];
            [jiazhiTableView tableViewDidFinishedLoading];
            [jiazhiTableView reloadData];
            break;}
        case 4:{
//            refreshing=NO;
            [anquanArray addObjectsFromArray:[dic objectForKey:@"list"]];
            [anquanTableView tableViewDidFinishedLoading];
            [anquanTableView reloadData];
            break;}
        default:
            break;
    }
}


-(void)sendQingqiu:(NSMutableString *)paramsStr//发起请求
{
    NSString *urlStr = [NSString stringWithFormat:@"http://zixun.www.net.cn/api/hichinaapp.php?%@",paramsStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}
-(NSMutableString *)jiamiAndpaixu:(NSDictionary *)params{//用于加密和排序
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
    [signStr release];
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
    return paramsStr;
}


-(void)segmentedControl:(UISegmentedControl *)sender{
    switch (seg.selectedSegmentIndex) {
        case 0:{
            //请求最新资讯
            [myScrollV setContentOffset:CGPointMake(0, 0) animated:YES];
             if (isZXfirst) {
                 [[SHKActivityIndicator currentIndicator]displayActivity:@"正在加载中..."];
            NSDictionary *params=[self getTheParamsWithPage:@"1" andType:@"updated"];
            NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
            [self sendQingqiu:paramsStr];//发异步请求
                 isZXfirst=NO;
             }
            break;
        }
        case 1:{
            //请求行业资讯
             [myScrollV setContentOffset:CGPointMake(320, 0) animated:YES];
             if (isHYfirst) {
                 [[SHKActivityIndicator currentIndicator]displayActivity:@"正在加载中..."];
            NSDictionary *params=[self getTheParamsWithPage:@"1" andType:@"industry"];
            NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
            [self sendQingqiu:paramsStr];//发异步请求
                 isHYfirst=NO;
             }
            break;
        }
        case 2:{
            //请求应用资讯
            [myScrollV setContentOffset:CGPointMake(640, 0) animated:YES];
             if (isYYfirst) {
                 [[SHKActivityIndicator currentIndicator]displayActivity:@"正在加载中..."];
            NSDictionary *params=[self getTheParamsWithPage:@"1" andType:@"application"];
            NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
            [self sendQingqiu:paramsStr];//发异步请求
                 isYYfirst=NO;
             }
            break;
        }
        case 3:{
            //请求价值资讯
            [myScrollV setContentOffset:CGPointMake(960, 0) animated:YES];
             if (isJZfirst) {
                 [[SHKActivityIndicator currentIndicator]displayActivity:@"正在加载中..."];
            NSDictionary *params=[self getTheParamsWithPage:@"1" andType:@"value"];
            NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
            [self sendQingqiu:paramsStr];//发异步请求
                 isJZfirst=NO;
             }
            break;
        } 
        case 4:{
            //请求安全资讯
            [myScrollV setContentOffset:CGPointMake(1280, 0) animated:YES];
             if (isAQfirst) {
                 [[SHKActivityIndicator currentIndicator]displayActivity:@"正在加载中..."];
            NSDictionary *params=[self getTheParamsWithPage:@"1" andType:@"security"];
            NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
            [self sendQingqiu:paramsStr];//发异步请求
                 isAQfirst=NO;
             }
            break;
        }
        default:
            break;
    }
}

-(void)refrash{
    switch (seg.selectedSegmentIndex) {
        case 0:{
            //请求最新资讯
                [[SHKActivityIndicator currentIndicator]displayActivity:@"正在加载中..."];
                NSDictionary *params=[self getTheParamsWithPage:@"1" andType:@"updated"];
                NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
                [self sendQingqiu:paramsStr];//发异步请求
                isZXfirst=NO;
            break;
        }
        case 1:{
            //请求行业资讯
                [[SHKActivityIndicator currentIndicator]displayActivity:@"正在加载中..."];
                NSDictionary *params=[self getTheParamsWithPage:@"1" andType:@"industry"];
                NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
                [self sendQingqiu:paramsStr];//发异步请求
                isHYfirst=NO;
            break;
        }
        case 2:{
            //请求应用资讯
                [[SHKActivityIndicator currentIndicator]displayActivity:@"正在加载中..."];
                NSDictionary *params=[self getTheParamsWithPage:@"1" andType:@"application"];
                NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
                [self sendQingqiu:paramsStr];//发异步请求
                isYYfirst=NO;
            break;
        }
        case 3:{
            //请求价值资讯
                [[SHKActivityIndicator currentIndicator]displayActivity:@"正在加载中..."];
                NSDictionary *params=[self getTheParamsWithPage:@"1" andType:@"value"];
                NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
                [self sendQingqiu:paramsStr];//发异步请求
                isJZfirst=NO;
            break;
        } 
        case 4:{
            //请求安全资讯
                [[SHKActivityIndicator currentIndicator]displayActivity:@"正在加载中..."];
                NSDictionary *params=[self getTheParamsWithPage:@"1" andType:@"security"];
                NSMutableString *paramsStr=[self jiamiAndpaixu:params];//先进行加密和排序
                [self sendQingqiu:paramsStr];//发异步请求
                isAQfirst=NO;
            break;
        }
        default:
            break;
    }
}


-(NSDictionary *)getTheParamsWithPage:(NSString *)pageStr andType:(NSString *)type{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"1.0",@"ver",
                            @"ios",@"client",
                            @"list",@"method",
                            @"news",@"module",
                            type,@"type",
                            pageStr,@"pageIndex",
                            @"20",@"pageSize",
                            [self timestamp],@"timestamp",
                            @"hello",@"appid",
                            @"111111",@"appkey",nil];
    return params;
}


-(NSString *)timestamp{
    NSString *timeStr=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
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
    [[SHKActivityIndicator currentIndicator]hideAfterDelay:0.5];
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
    [receiveStr release];
    NSLog(@"%@",dic);
    
    switch (seg.selectedSegmentIndex) {
        case 0:{
            [zuixinArray removeAllObjects];
            [zuixinArray addObjectsFromArray:[dic objectForKey:@"list"]];
//            refreshing=NO;
            [zuixinTableView tableViewDidFinishedLoading];
            [zuixinTableView reloadData];
            break;}
            
        case 1:{
            [hangyeArray removeAllObjects];
            [hangyeArray addObjectsFromArray:[dic objectForKey:@"list"]];
//            refreshing=NO;
            [hangyeTableView tableViewDidFinishedLoading];
            [hangyeTableView reloadData];
            break;}
            
        case 2:{
            [yingyongArray removeAllObjects];
            [yingyongArray addObjectsFromArray:[dic objectForKey:@"list"]];
//            refreshing=NO;
            [yingyongTableView tableViewDidFinishedLoading];
            [yingyongTableView reloadData];
            break;}
            
        case 3:{
            [jiazhiArray removeAllObjects];
            [jiazhiArray addObjectsFromArray:[dic objectForKey:@"list"]];
//            refreshing=NO;
            [jiazhiTableView tableViewDidFinishedLoading];
            [jiazhiTableView reloadData];
            break;}
            
        case 4:{
            [anquanArray removeAllObjects];
            [anquanArray addObjectsFromArray:[dic objectForKey:@"list"]];
//            refreshing=NO;
            [anquanTableView tableViewDidFinishedLoading];
            [anquanTableView reloadData];
            break;}
            
        default:
            break;
    }
//    [zuixinTableView reloadData];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error
{
    NSLog(@"%@",[error debugDescription]);
}
#pragma mark - 关于资讯的单独⺴⽹网络请求 ----结束----

                                
#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==zuixinTableView) {
        return [zuixinArray count];
    }
    else if(tableView==hangyeTableView){
        return [hangyeArray count];
    }
    else if(tableView==yingyongTableView){
        return [yingyongArray count];
    }
    else if(tableView==jiazhiTableView){
        return [jiazhiArray count];
    }
    else{
        return [anquanArray count];
    }
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
    NSDictionary *dic;
    if (tableView==zuixinTableView) {
        dic=[zuixinArray objectAtIndex:indexPath.row];
    }
    else if(tableView==hangyeTableView){
        dic=[hangyeArray objectAtIndex:indexPath.row];
    }
    else if(tableView==yingyongTableView){
        dic=[yingyongArray objectAtIndex:indexPath.row];
    }
    else if(tableView==jiazhiTableView){
       dic=[jiazhiArray objectAtIndex:indexPath.row];
    }
    else if(tableView==anquanTableView){
        dic=[anquanArray objectAtIndex:indexPath.row];
    }
    UILabel *myTextLabel=(UILabel *)[cell viewWithTag:200];
    myTextLabel.text=[dic objectForKey:@"title"];
    UILabel *myDetailTextLabel=(UILabel *)[cell viewWithTag:300];
    myDetailTextLabel.text=[dic objectForKey:@"description"];
    UILabel *timeL=(UILabel *)[cell viewWithTag:100];
    timeL.text=[dic objectForKey:@"date"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZixunXiangqingVC *zxxqVC=[[ZixunXiangqingVC alloc]init];
    zxxqVC.navigationController.navigationBarHidden=YES;
    switch (seg.selectedSegmentIndex) {
        case 0:{
            NSDictionary *dic=[zuixinArray objectAtIndex:indexPath.row];
            NSString *num=[dic objectForKey:@"id"];
            zxxqVC.numStr=num;
            [self.navigationController pushViewController:zxxqVC animated:YES];
            [zxxqVC release];
            zxxqVC.titleL.text=@"最新资讯";
            break;}
            
        case 1:{
            NSDictionary *dic=[hangyeArray objectAtIndex:indexPath.row];
            NSString *num=[dic objectForKey:@"id"];
            zxxqVC.numStr=num;
            [self.navigationController pushViewController:zxxqVC animated:YES];
            [zxxqVC release];
            zxxqVC.titleL.text=@"行业资讯";
            break;}
            
        case 2:{
            NSDictionary *dic=[yingyongArray objectAtIndex:indexPath.row];
            NSString *num=[dic objectForKey:@"id"];
            zxxqVC.numStr=num;
            [self.navigationController pushViewController:zxxqVC animated:YES];
            [zxxqVC release];
            zxxqVC.titleL.text=@"应用资讯";
            break;}
            
        case 3:{
            NSDictionary *dic=[jiazhiArray objectAtIndex:indexPath.row];
            NSString *num=[dic objectForKey:@"id"];
            zxxqVC.numStr=num;
            [self.navigationController pushViewController:zxxqVC animated:YES];
            [zxxqVC release];
            zxxqVC.titleL.text=@"价值资讯";
            break;}
            
        case 4:{
            NSDictionary *dic=[anquanArray objectAtIndex:indexPath.row];
            NSString *num=[dic objectForKey:@"id"];
            zxxqVC.numStr=num;
            [self.navigationController pushViewController:zxxqVC animated:YES];
            [zxxqVC release];
            zxxqVC.titleL.text=@"安全资讯";
            break;}
            
        default:
            break;
    }
}



-(void)toZhuye{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)dealloc
{
    [zuixinTableView release];
    [hangyeTableView release];
    [yingyongTableView release];
    [jiazhiTableView release];
    [anquanTableView release];
    [receiveData release];
    [zuixinArray release];
    [hangyeArray release];
    [yingyongArray release];
    [jiazhiArray release];
    [anquanArray release];
    [myScrollV release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    zuixinTableView=nil;
    hangyeTableView=nil;
    yingyongTableView=nil;
    jiazhiTableView=nil;
    anquanTableView=nil;
    myScrollV=nil;
    zuixinArray=nil;
    hangyeArray=nil;
    yingyongArray=nil;
    jiazhiArray=nil;
    anquanArray=nil;
    receiveData=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
