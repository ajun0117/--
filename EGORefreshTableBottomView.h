//
//  EGORefreshTableBottomView.h
//  万网
//
//  Created by Ibokan on 12-12-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
    EGOOPullRefreshPullingToo = 0,
    EGOOPullRefreshNormalToo,
    EGOOPullRefreshLoadingToo,   
} EGOPullRefreshStateToo;

@protocol EGORefreshTableBottomDelegate;
@interface EGORefreshTableBottomView : UIView{
    id _delegate;
    EGOPullRefreshStateToo _state;
    
    UILabel *_lastUpdatedLabel;
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <EGORefreshTableBottomDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol EGORefreshTableBottomDelegate
- (void)egoRefreshTableBottomDidTriggerRefresh:(EGORefreshTableBottomView*)view;
- (BOOL)egoRefreshTableBottomDataSourceIsLoading:(EGORefreshTableBottomView*)view;
@optional
- (NSDate*)egoRefreshTableBottomDataSourceLastUpdated:(EGORefreshTableBottomView*)view;

@end
