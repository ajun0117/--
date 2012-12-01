//
//  AppDelegate.m
//  万网
//
//  Created by Ibokan on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ShouyeVC.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self zhuceTokenmrthod];
    ShouyeVC *shouVC=[[ShouyeVC alloc]init];
    self.window.rootViewController=shouVC;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)zhuceTokenmrthod{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"860173013153543oo",@"token", nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            dic,@"data",
                            @"1.0",@"v",
                            @"Tokenmrthod",@"method",
                            @"ios",@"client",nil];
    NSURL *url=[NSURL URLWithString:@"http://hiapp.hichina.com/hiapp/json/tokenmrthod/"];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    NSString *arguments=[NSString stringWithFormat:@"req=%@",params];
    NSData *postData=[arguments dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    NSError *error;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    [request release];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
