//
//  AppDelegate.m
//  ShopManager
//
//  Created by 张旭 on 2/22/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "AppDelegate.h"

#import <AVOSCloud/AVOSCloud.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)setupToastStyle {
	CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
	style.messageFont = [UIFont systemFontOfSize:13];
	[CSToastManager setSharedStyle:style];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[Fabric with:@[[Crashlytics class]]];
    [IQKeyboardManager sharedManager].enable = YES;

	[self setupToastStyle];

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    //请求接受推送
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    //在应用未启动收到消息时启动取出消息
    //NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    //设置appid和key（对应web端应用的appid 和 appkey）
    [AVOSCloud setApplicationId:@"z0fV9FmLCFVq1BPnwbCTOxh1-gzGzoHsz"
                      clientKey:@"ds0mi0CVaLmg3Gww7MQxa8Ud"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Receive DeviceToken: %@", deviceToken);
    
    NSString *token = [[deviceToken description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:DEVICECODE];
    //将deviceToken保存到云平台
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败，无法获取设备 ID, 具体错误: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 	{
    NSLog(@"%@", userInfo);
}

@end
