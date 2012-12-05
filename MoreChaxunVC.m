//
//  MoreChaxunVC.m
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreChaxunVC.h"
#import "ChaxunVC.h"
#import "HouzhuiListVC.h"
#import "JSON.h"
#import "SHKActivityIndicator.h"
#define ENGLISH @"最多可搜索十个域名,每行输入一个,如:\ntabobao\nsina\nbbboo"
#define CHINA @"最多可搜索十个域名,每行输入一个,如:\n淘宝.com\n新浪.com\n中国.com"

@implementation MoreChaxunVC
@synthesize englishBtn,chinaBtn;
@synthesize searchV;
@synthesize placeL;
@synthesize selectedArray;
@synthesize receiveData;
@synthesize resultArray;
@synthesize resultTableView;
//@synthesize lineArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.lineArray=[NSMutableArray array];
        self.selectedArray=[NSMutableArray array];//数组初始化
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
    [selectedArray addObject:@".com"];//默认选择.com后缀
    lineCount=0;
    isChina=NO;
    UIImageView *bgIM=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"suffix_background.png"]];
    bgIM.frame=CGRectMake(0, 0, 320, 460);
    [self.view addSubview:bgIM];
    [bgIM release];
    
    UIImageView *topIM=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    topIM.image=[UIImage imageNamed:@"top.png"];
    topIM.userInteractionEnabled=YES;
    [self.view addSubview:topIM];
    [topIM release];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.center=topIM.center;
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=UITextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:18];
    label.text=@"域名查询";
    [topIM addSubview:label];
    [label release];
    
    UIButton *fanhuiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fanhuiBtn.frame=CGRectMake(5, 5, 50, 30);
    [fanhuiBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    fanhuiBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    [fanhuiBtn setTitle:@"主页" forState:UIControlStateNormal];
    [fanhuiBtn addTarget:self action:@selector(toZhuye) forControlEvents:UIControlEventTouchUpInside];
    [topIM addSubview:fanhuiBtn];
    
    UIButton *moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame=CGRectMake(265, 5, 50, 30);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"rightbutton.png"] forState:UIControlStateNormal];
    moreBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    [moreBtn setTitle:@"单域名" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    [topIM addSubview:moreBtn];
    
    self.englishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [englishBtn setImage:[UIImage imageNamed:@"notselected.png"] forState:UIControlStateNormal];
    [englishBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    [englishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [englishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [englishBtn setTitle:@"    英文" forState:UIControlStateNormal];
    [englishBtn setTitle:@"    英文" forState:UIControlStateSelected];
    [englishBtn addTarget:self action:@selector(english) forControlEvents:UIControlEventTouchUpInside];
    englishBtn.frame=CGRectMake(60, 44+15, 80, 20);
    [self.view addSubview:englishBtn];
    englishBtn.selected=YES;
    
    self.chinaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [chinaBtn setImage:[UIImage imageNamed:@"notselected.png"] forState:UIControlStateNormal];
    [chinaBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    [chinaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [chinaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [chinaBtn setTitle:@"    中文" forState:UIControlStateNormal];
    [chinaBtn setTitle:@"    中文" forState:UIControlStateSelected];
    [chinaBtn addTarget:self action:@selector(china) forControlEvents:UIControlEventTouchUpInside];
    chinaBtn.frame=CGRectMake(160, 44+15, 80, 20);
    [self.view addSubview:chinaBtn];
    
    self.searchV=[[UITextView alloc]initWithFrame:CGRectMake(20, 44+40, 280, 112)];
    searchV.delegate=self;
    [searchV setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"search_more.png"]]];
    [self.view addSubview:searchV];
    searchV.textColor=[UIColor grayColor];
    searchV.text=ENGLISH;
    [searchV release];
    
    UIButton *houBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    houBtn.frame=CGRectMake(20, 44+40+120, 80, 20);
    houBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [houBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [houBtn setBackgroundImage:[UIImage imageNamed:@"suffbutton_more.png"] forState:UIControlStateNormal];
    [houBtn setTitle:@"后缀选择" forState:UIControlStateNormal];
    [houBtn addTarget:self action:@selector(houzhuXuanze) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:houBtn];
    
    UIButton *starBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    starBtn.frame=CGRectMake(220, 44+40+120, 80, 20);
    starBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [starBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [starBtn setBackgroundImage:[UIImage imageNamed:@"suffbutton_more.png"] forState:UIControlStateNormal];
    [starBtn addTarget:self action:@selector(startChaxun) forControlEvents:UIControlEventTouchUpInside];
    [starBtn setTitle:@"开始查询" forState:UIControlStateNormal];
    [self.view addSubview:starBtn];
    
    self.resultTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 240, 320, 460-240) style:UITableViewStyleGrouped];
    resultTableView.backgroundColor=[UIColor clearColor];
    resultTableView.delegate=self;
    resultTableView.dataSource=self;
    resultTableView.hidden=YES;         //初始隐藏
    [self.view addSubview:resultTableView];
    [resultTableView release];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *theText=[textView.text stringByReplacingCharactersInRange:range withString:text];
    NSArray *lineArray=[theText componentsSeparatedByString:@"\n"];
    for (UIView *im in searchV.subviews) {//先删除所有横线
        if ([im isKindOfClass:[UIImageView class]]) {
            [im removeFromSuperview];
        }
    }
    for (int i=0; i<[lineArray count]; i++) {//根据数组元素个数来重新划线
        [self addTheLine:CGRectMake(0, 20+15*i, 280, 1)];
    }
    if ([theText isEqualToString:@""]) {//当文本为空时 删除所有的横线
        for (UIView *im in searchV.subviews) {
            if ([im isKindOfClass:[UIImageView class]]) {
                [im removeFromSuperview];
            }
        }
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:ENGLISH]||[textView.text isEqualToString:CHINA]) {
        searchV.textColor=[UIColor blackColor];
        searchV.text=@"";
    }
}


#pragma mark---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [resultArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ind=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ind];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ind];
    }
    if (tableView==resultTableView) {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        NSDictionary *dic=[resultArray objectAtIndex:indexPath.row];
        NSString *text = [dic objectForKey:@"name"];
        cell.textLabel.text=text;
    }
    return cell;
}


-(void)addTheLine:(CGRect)frame{
    UIImageView *theLine=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"虚线.png"]];
    theLine.frame=frame;
    [searchV addSubview:theLine];
    [theLine release];
}

-(void)houzhuXuanze{
    HouzhuiListVC *houzhuiVC=[[HouzhuiListVC alloc]init];
    houzhuiVC.isChina=isChina;
    houzhuiVC.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:houzhuiVC animated:YES];
    [houzhuiVC release];
}

#pragma mark- 请求时间戳
-(NSString *)timestamp{
    NSString *timeStr=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSLog(@"timeStr----%@",timeStr);
    return timeStr;
}

-(void)startChaxun{
    [searchV resignFirstResponder];
    resultTableView.hidden=NO;
    [[SHKActivityIndicator currentIndicator]displayActivity:@"多域名查询中..."];
    NSMutableArray *array=[NSMutableArray array];
    for (NSString *str in selectedArray) {
        NSString *wanzhengStr=[NSString stringWithFormat:@"%@%@",searchV.text,str];
        NSString *encodeStr=[wanzhengStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//进行编码
        [array addObject:encodeStr];
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"123.com",@"123.cn", nil],@"domainnames", nil];
    NSLog(@"dic----%@",dic);
    NSString *tokenStr=[NSString stringWithFormat:@"%@_%@",TOKEN,[self timestamp]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            dic,@"data",
                            @"1.0",@"v",
                            @"checkdomain",@"method",
                            tokenStr,@"trid",
                            @"ios",@"client",nil];
    NSURL *url=[NSURL URLWithString:@"http://hiapp.hichina.com/hiapp/json/checkdomain/"];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    NSString *arguments=[NSString stringWithFormat:@"req=%@",params];
    NSLog(@"arguments -----%@",arguments);
    NSData *postData=[arguments dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [request release];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.receiveData=[NSMutableData data];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receiveData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [[SHKActivityIndicator currentIndicator]hideAfterDelay:0.5];
    NSLog(@"receiveData-------------%@",receiveData);
    NSString *receiveStr=[[NSString alloc]initWithData:receiveData encoding:NSUTF8StringEncoding];
    NSDictionary *dic=[receiveStr JSONValue];
    NSLog(@"dic-------------%@",dic);
    NSDictionary *dicc=[dic objectForKey:@"results"];
    [resultArray removeAllObjects];
    [resultArray addObjectsFromArray:[dicc objectForKey:@"domainnames"]];
    [resultTableView reloadData];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error----------%@",[error localizedDescription]);
}



-(void)english{
    if (chinaBtn.selected==YES) {
        [searchV resignFirstResponder];
        searchV.textColor=[UIColor grayColor];
        searchV.text=ENGLISH;
        isChina=NO;
        chinaBtn.selected=NO;
        englishBtn.selected=YES;
    }
}

-(void)china{
    if (englishBtn.selected==YES) {
        [searchV resignFirstResponder];
        searchV.textColor=[UIColor grayColor];
        searchV.text=CHINA;
        englishBtn.selected=NO;
        chinaBtn.selected=YES;
        isChina=YES;
    }
}

-(void)toZhuye{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)more{
    ChaxunVC *chaVC=[[ChaxunVC alloc]init];
    chaVC.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:chaVC animated:YES];
}

-(void)dealloc{
    [englishBtn release];
    [chinaBtn release];
    [searchV release];
    [placeL release];
    [selectedArray release];
    [receiveData release];
    [resultArray release];
    [resultTableView release];
    [super dealloc];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    englishBtn=nil;
    chinaBtn=nil;
    searchV=nil;
    placeL=nil;
    selectedArray=nil;//选择的后缀列表
    receiveData=nil;
    resultArray=nil;
    resultTableView=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
