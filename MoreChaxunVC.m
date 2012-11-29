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
#define ENGLISH @"最多可搜索十个域名,每行输入一个,如:\ntabobao\nsina\nbbboo"
#define CHINA @"最多可搜索十个域名,每行输入一个,如:\n淘宝.com\n新浪.com\n中国.com"

@implementation MoreChaxunVC
@synthesize englishBtn,chinaBtn;
@synthesize searchV;
@synthesize placeL;
//@synthesize lineArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.lineArray=[NSMutableArray array];
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
    
//    self.placeL=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 280, 50)];//添加显示提示文字的Lable
//    placeL.textColor=[UIColor grayColor];
//    placeL.backgroundColor=[UIColor clearColor];
//    placeL.text=@"最多可搜索十个域名,每行输入一个,如:\ntabobao\nsina\nbbboo";
//    placeL.font=[UIFont systemFontOfSize:12];
//    placeL.lineBreakMode=UILineBreakModeWordWrap;
//    placeL.numberOfLines=0;
//
//    [searchV addSubview:placeL];
//    [placeL release];
    
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
}

-(void)startChaxun{
    
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
