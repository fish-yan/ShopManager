//
// Created by 张旭 on 9/6/16.
// Copyright (c) 2016 薛焱. All rights reserved.
//

#import "AdViewModel.h"

@interface AdViewModel()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) YYCache *adCache;

@end

@implementation AdViewModel

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _sessionManager.responseSerializer.acceptableContentTypes = [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObject:@"text/plain"]];
        _sessionManager.responseSerializer.acceptableContentTypes = [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObject:@"text/html"]];
    }
    return _sessionManager;
}

- (void)dealloc {
    [self.sessionManager invalidateSessionCancelingTasks:YES];
}

- (instancetype)init {
    self = [super init];
    [self loadFromDisk];
    [self request];
    return self;
}

- (YYCache *)adCache {
    if (_adCache == nil) {
        _adCache = [[YYCache alloc] initWithName:@"adCache"];
    }
    return _adCache;
}

- (BOOL)shouldSkip {
    return self.adImageList == nil;
}

- (void)loadFromDisk {
    self.adImageList = (NSArray *)[self.adCache objectForKey:@"adImageList"];
    self.adURLList = (NSArray *)[self.adCache objectForKey:@"adURLList"];
}

- (void)request {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"3" forKey:@"appCode"];
    [self.sessionManager GET:@"http://typt.cjm168.com/appInterface/getAppAds.do" parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"isSuccess"] isEqualToString:@"1"]) {
            NSMutableArray<UIImage *> *imageList = [NSMutableArray array];
            NSMutableArray<NSString *> *urlList = [NSMutableArray array];
            NSArray *data = result[@"data"];
            for (NSDictionary *item in data) {
                NSString *imageUrl = item[@"PICURL"];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
                NSString *url = item[@"PICTARGET"];
                if (![url containsString:@"http://"]) {
                    url = [NSString stringWithFormat:@"http://%@", url];
                }
                [imageList addObject:image];
                [urlList addObject:url];
            }
            if (imageList.count == 0) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self.adCache removeObjectForKey:@"adImageList"];
                    [self.adCache removeObjectForKey:@"adURLList"];
                });
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self.adCache setObject:imageList forKey:@"adImageList"];
                    [self.adCache setObject:urlList forKey:@"adURLList"];
                });
            }
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self.adCache removeObjectForKey:@"adImageList"];
                [self.adCache removeObjectForKey:@"adURLList"];
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        [JDStatusBarNotification showWithStatus:ERROR_NETWORK dismissAfter:2];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.adCache removeObjectForKey:@"adImageList"];
            [self.adCache removeObjectForKey:@"adURLList"];
        });
    }];
}

@end