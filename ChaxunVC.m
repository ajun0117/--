//
//  ChaxunVC.m
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChaxunVC.h"
#import "MoreChaxunVC.h"
#import "JSON.h"
#import "WhoIsVC.h"
#import "SHKActivityIndicator.h"

@implementation ChaxunVC
@synthesize searTextF;
@synthesize englishBtn,chinaBtn;
@synthesize listTableView;
@synthesize englishH,chinaH;
@synthesize receiveData;
@synthesize resultTableView;
@synthesize resultArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializationd
        self.englishH=[NSMutableArray array];
        self.chinaH=[NSMutableArray array];
        self.resultArray=[NSMutableArray array];
        isChina=NO;
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
    
    UIImageView *bgIM=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_one.png"]];
    bgIM.frame=CGRectMake(0, 0, 320, 460);
    [self.view addSubview:bgIM];
    [bgIM release];
    
    UIImageView *middleM=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backimage_one.png"]];
    middleM.frame=CGRectMake(0, 0, 130, 130);
    middleM.center=self.view.center;
    [self.view addSubview:middleM];
    [middleM release];
    
    self.listTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 120-460, 320, 460-120) style:UITableViewStylePlain];
    listTableView.delegate=self;
    listTableView.dataSource=self;
    [self.view addSubview:listTableView];
    [listTableView release];
    
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
    [moreBtn setTitle:@"多域名" forState:UIControlStateNormal];
     [moreBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    [topIM addSubview:moreBtn];
    
    self.searTextF=[[UITextField alloc]initWithFrame:CGRectMake(20, 44+17, 240, 25)];
    searTextF.delegate=self;
    searTextF.keyboardType=UIKeyboardTypeURL;
    searTextF.clearButtonMode=UITextFieldViewModeWhileEditing;//出现清除文字的小叉叉
    [searTextF setBackground:[UIImage imageNamed:@"seachbox.png"]];
    searTextF.placeholder=@"请您输入英文域名:taobao.com";
    [self.view addSubview:searTextF];
    [searTextF release];
    
    UIButton *searBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [searBtn setBackgroundImage:[UIImage imageNamed:@"searchbar.png"] forState:UIControlStateNormal];
    [searBtn addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    searBtn.frame=CGRectMake(280, 44+17+2, 20, 20);
    [self.view addSubview:searBtn];
    
    self.englishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [englishBtn setImage:[UIImage imageNamed:@"notselected.png"] forState:UIControlStateNormal];
    [englishBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    [englishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [englishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [englishBtn setTitle:@"    英文" forState:UIControlStateNormal];
    [englishBtn setTitle:@"    英文" forState:UIControlStateSelected];
    [englishBtn addTarget:self action:@selector(english) forControlEvents:UIControlEventTouchUpInside];
    englishBtn.frame=CGRectMake(40, 44+15+40, 80, 20);
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
    chinaBtn.frame=CGRectMake(140, 44+15+40, 80, 20);
    [self.view addSubview:chinaBtn];
    
    self.resultTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 120, 320, 460-120) style:UITableViewStyleGrouped];
    resultTableView.backgroundColor=[UIColor clearColor];
    resultTableView.delegate=self;
    resultTableView.dataSource=self;
    resultTableView.hidden=YES;
    [self.view addSubview:resultTableView];
    [resultTableView release];
    
}
-(void)english{
    if (chinaBtn.selected==YES) {
        searTextF.placeholder=@"请您输入英文域名:taobao.com";
        listTableView.frame=CGRectMake(0, 120-460, 320, 460-120);
        isChina=NO;
        chinaBtn.selected=NO;
        englishBtn.selected=YES;
    }
}

-(void)china{
    if (englishBtn.selected==YES) {
        searTextF.placeholder=@"请您输入中文域名:淘宝.com";
         searTextF.keyboardType=UIKeyboardTypeDefault;
        listTableView.frame=CGRectMake(0, 120-460, 320, 460-120);
        englishBtn.selected=NO;
        chinaBtn.selected=YES;
        isChina=YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    resultTableView.hidden=YES;
    [UIView animateWithDuration:0.3 animations:^{
        listTableView.frame=CGRectMake(0,120, 320, 460-120);
    }];
    NSString *text=[textField.text stringByReplacingCharactersInRange:range withString:string];//这个代理是分两段的，所以需要拼接
    if ([text isEqualToString:@""]) {
        [chinaH removeAllObjects];
        [englishH removeAllObjects];
        listTableView.frame=CGRectMake(0, 120-460, 320, 460-120);
    }
    else{
    if (isChina) {
        [chinaH removeAllObjects];
        [chinaH addObjectsFromArray:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@.com",text],
                                     [NSString stringWithFormat:@"%@.net",text],
                                       [NSString stringWithFormat:@"%@.tv",text],
                                     [NSString stringWithFormat:@"%@.biz",text],
                                     [NSString stringWithFormat:@"%@.cc",text],
                                     [NSString stringWithFormat:@"%@.公司",text],
                                     [NSString stringWithFormat:@"%@.网络",text],
                                     [NSString stringWithFormat:@"%@.中国",text],nil]];
    }
    else{
    [englishH removeAllObjects];
    [englishH addObjectsFromArray:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@.com",text],
                                   [NSString stringWithFormat:@"%@.cn",text],
              [NSString stringWithFormat:@"%@.mobi",text],[NSString stringWithFormat:@"%@.co",text],
                                   [NSString stringWithFormat:@"%@.net",text],[NSString stringWithFormat:@"%@.com.cn",text],
                                   [NSString stringWithFormat:@"%@.net.cn",text],[NSString stringWithFormat:@"%@.so",text],
                                   [NSString stringWithFormat:@"%@.org",text],[NSString stringWithFormat:@"%@.gov.cn",text],
                                   [NSString stringWithFormat:@"%@.org.cn",text],[NSString stringWithFormat:@"%@.tel",text],
                                   [NSString stringWithFormat:@"%@.tv",text],[NSString stringWithFormat:@"%@.biz",text],
                                   [NSString stringWithFormat:@"%@.cc",text],[NSString stringWithFormat:@"%@.hk",text],
                                   [NSString stringWithFormat:@"%@.name",text],[NSString stringWithFormat:@"%@.info",text],
                                   [NSString stringWithFormat:@"%@.asia",text],[NSString stringWithFormat:@"%@.me",text],nil] ];
    }
    }
    [listTableView reloadData];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [chinaH removeAllObjects];
    [englishH removeAllObjects];
    listTableView.frame=CGRectMake(0, 120-460, 320, 460-120);
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
             
    return YES;
}


#pragma mark---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==resultTableView) {
        return [resultArray count];
    }
    else{
        if (isChina) {
            return [chinaH count];
        }
            return [englishH count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ind=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ind];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ind];
        if (tableView==resultTableView) {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(200, 16, 60, 15)];
            label.tag=100;
            [cell addSubview:label];
            UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
            button1.tag=200;
            button1.frame=CGRectMake(260, 10, 20, 20);
            [cell addSubview:button1];
            UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
            button2.frame=CGRectMake(290, 10, 20, 20);
            [cell addSubview:button2];
            [button2 setBackgroundImage:[UIImage imageNamed:@"keep.png"] forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(shoucang:) forControlEvents:UIControlEventTouchUpInside];
            [label release];
        }
    }
    if (tableView==resultTableView) {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        NSDictionary *dic=[resultArray objectAtIndex:indexPath.row];
        NSString *text = [dic objectForKey:@"name"];
        cell.textLabel.text=text;
        UILabel *label=(UILabel *)[cell viewWithTag:100];
        UIButton *button1=(UIButton *)[cell viewWithTag:200];
        if ([[dic objectForKey:@"status"] intValue]==0) {
            label.textColor=[UIColor greenColor];
            label.text=@"未注册";
            [button1 setBackgroundImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
            [button1 removeTarget:self action:@selector(toWhoIs:) forControlEvents:UIControlEventTouchUpInside];
            [button1 addTarget:self action:@selector(toBuyIt:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            label.textColor=[UIColor redColor];
             label.text=@"已注册";
            [button1 setBackgroundImage:[UIImage imageNamed:@"detailbutton.png"] forState:UIControlStateNormal];
            [button1 removeTarget:self action:@selector(toBuyIt:) forControlEvents:UIControlEventTouchUpInside];
            [button1 addTarget:self action:@selector(toWhoIs:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else{
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        if (isChina) {
        cell.textLabel.text=[chinaH objectAtIndex:indexPath.row];
        }
        else{
        cell.textLabel.text=[englishH objectAtIndex:indexPath.row];
        }
    }
    return cell;
}


-(void)toBuyIt:(UIButton *)sender{
    NSLog(@"买它");
}

-(void)toWhoIs:(UIButton *)sender{
    NSLog(@"WhoIs");
    WhoIsVC *whoVC=[[WhoIsVC alloc]init];
    UITableViewCell *cell=(UITableViewCell *)sender.superview;
    whoVC.nameStr=cell.textLabel.text;
    whoVC.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:whoVC animated:YES];
    [whoVC release];
}

-(void)shoucang:(UIButton *)sender{
    NSLog(@"收藏它");
}

#pragma mark- 请求时间戳
-(NSString *)timestamp{
    NSString *timeStr=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSLog(@"timeStr----%@",timeStr);
    return timeStr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==listTableView) {
        [[SHKActivityIndicator currentIndicator]displayActivity:@"单域名查询中..."];
    listTableView.frame=CGRectMake(0, 120-460, 320, 460-120);
    resultTableView.hidden=NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [self.searTextF resignFirstResponder];
    searTextF.text=cell.textLabel.text;
    NSString *encodeStr=[searTextF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//进行编码
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:encodeStr,@"domainnames", nil];
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


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searTextF resignFirstResponder];
}

-(void)toSearch{
    [searTextF resignFirstResponder];
    listTableView.frame=CGRectMake(0, 120-460, 320, 460-120);
    resultTableView.hidden=NO;
    
    [[SHKActivityIndicator currentIndicator]displayActivity:@"正在请求中..." inView:self.view];
    
    NSString *encodeStr=[searTextF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//进行编码
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:encodeStr,@"domainnames", nil];
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

-(void)toZhuye{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)more{
    MoreChaxunVC *moreVC=[[MoreChaxunVC alloc]init];
    moreVC.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)dealloc
{
    [searTextF release];
    [englishH release];
    [chinaH release];
    [englishBtn release];
    [chinaBtn release];
    [listTableView release];
    [receiveData release];
    [resultTableView release];
    [resultArray release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    searTextF=nil;
    englishBtn=nil;
    chinaBtn=nil;
    listTableView=nil;
    englishH=nil;
    chinaH=nil;
    receiveData=nil;
    resultTableView=nil;
    resultArray=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
