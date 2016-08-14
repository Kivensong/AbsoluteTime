//
//  ViewController.m
//  AbsoluteTime
//
//  Created by kivensong on 16/8/12.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "ViewController.h"
#import <sys/sysctl.h>

#define  SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define  SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


#define WIDTH(view) (view.bounds.size.width)
#define HEIGHT(view) (view.bounds.size.height)

static const int kUpdateTimeInterval = 1;

@interface ViewController ()

@property (nonatomic, assign) CFTimeInterval caCurrentMediaTimeIntreval;
@property (nonatomic, assign) NSTimeInterval timeIntervalSince1970Interval;
@property (nonatomic, assign) NSTimeInterval processInfoSystemUptimeInterval;
@property (nonatomic, assign) time_t systemUpTimeInterval;
@property (nonatomic, strong) NSTimer *updateTimer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.caCurrentMediaTimeIntreval = CACurrentMediaTime();
    self.timeIntervalSince1970Interval = [[NSDate date] timeIntervalSince1970];
    self.processInfoSystemUptimeInterval = [[NSProcessInfo processInfo] systemUptime];
    self.systemUpTimeInterval = [self systemUpTime];
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:kUpdateTimeInterval target:self selector:@selector(refreshTimeData) userInfo:nil repeats:YES];
}

- (void)refreshTimeData
{
    self.caCurrentMediaTimeLabel.text = [self medisLableString];
    self.caCurrentMediaTimeLabel.font = [UIFont systemFontOfSize:8];
    [self.caCurrentMediaTimeLabel sizeToFit];
    self.caCurrentMediaTimeLabel.backgroundColor = [UIColor blueColor];
    self.caCurrentMediaTimeLabel.frame = CGRectMake(0.5*(SCREEN_WIDTH-WIDTH(self.caCurrentMediaTimeLabel)), self.caCurrentMediaTimeLabel.frame.origin.y, WIDTH(self.caCurrentMediaTimeLabel), HEIGHT(self.caCurrentMediaTimeLabel));
    
    self.timeIntervalSince1970Label.text = [self nsdataLabelString];
    self.timeIntervalSince1970Label.font = [UIFont systemFontOfSize:8];
    [self.timeIntervalSince1970Label sizeToFit];
    self.timeIntervalSince1970Label.backgroundColor = [UIColor greenColor];
    self.timeIntervalSince1970Label.frame = CGRectMake(0.5*(SCREEN_WIDTH-WIDTH(self.timeIntervalSince1970Label)), self.caCurrentMediaTimeLabel.frame.origin.y+(HEIGHT(self.caCurrentMediaTimeLabel))+ 50, WIDTH( self.timeIntervalSince1970Label), HEIGHT( self.timeIntervalSince1970Label));
    
    self.processInfoSystemUptimeLabel.text = [self processInfoTimeLabelString];
    self.processInfoSystemUptimeLabel.font = [UIFont systemFontOfSize:8];
    [self.processInfoSystemUptimeLabel sizeToFit];
    self.processInfoSystemUptimeLabel.backgroundColor = [UIColor yellowColor];
    self.processInfoSystemUptimeLabel.frame = CGRectMake(0.5*(SCREEN_WIDTH-WIDTH(self.processInfoSystemUptimeLabel)), self.timeIntervalSince1970Label.frame.origin.y+(HEIGHT(self.timeIntervalSince1970Label))+ 50, WIDTH( self.processInfoSystemUptimeLabel), HEIGHT( self.processInfoSystemUptimeLabel));
    
    self.systemUpTimeLabel.text = [self upTimeLabelString];
    self.systemUpTimeLabel.font = [UIFont systemFontOfSize:8];
    [self.systemUpTimeLabel sizeToFit];
    self.systemUpTimeLabel.backgroundColor = [UIColor redColor];
    self.systemUpTimeLabel.frame = CGRectMake(0.5*(SCREEN_WIDTH-WIDTH(self.systemUpTimeLabel)), self.processInfoSystemUptimeLabel.frame.origin.y+(HEIGHT(self.processInfoSystemUptimeLabel))+ 50, WIDTH( self.systemUpTimeLabel), HEIGHT( self.systemUpTimeLabel));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshTimeData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString*)medisLableString
{
    CFTimeInterval nowMediaTime = CACurrentMediaTime();
    int elapseMediaTime = nowMediaTime - self.caCurrentMediaTimeIntreval;
    return [NSString stringWithFormat:@"CACurrentMediaTime(): now:%.0f start:%.0f escalpe:%d", nowMediaTime, self.caCurrentMediaTimeIntreval, elapseMediaTime];
}

- (NSString*)nsdataLabelString
{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    int elapse = nowTime - self.timeIntervalSince1970Interval;
    return [NSString stringWithFormat:@"[[NSDate date] timeIntervalSince1970]: now:%.0f start:%.0f escalpe:%d", nowTime, self.timeIntervalSince1970Interval, elapse];
}

- (NSString*)processInfoTimeLabelString
{
    NSTimeInterval nowTime = [[NSProcessInfo processInfo] systemUptime];
    int elapse = nowTime - self.processInfoSystemUptimeInterval;
    return [NSString stringWithFormat:@"[[NSProcessInfo processInfo] systemUptime]: now:%.0f start:%.0f escalpe:%d", nowTime, self.processInfoSystemUptimeInterval, elapse];
}

- (NSString*)upTimeLabelString
{
    time_t nowTime = [self systemUpTime];
    long elapse = nowTime - self.systemUpTimeInterval;
    return [NSString stringWithFormat:@"SelfSystemUpTime: now:%ld start:%ld escalpe:%ld", nowTime, self.systemUpTimeInterval, elapse];
}

- (time_t)systemUpTime
{
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;
    
    (void)time(&now);
    
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
    {
        uptime = now - boottime.tv_sec;
    }
    
    return uptime;
}

@end
