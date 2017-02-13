//
//  RequestViewModel.m
//  BTBSeller
//
//  Created by 张旭 on 8/18/16.
//  Copyright © 2016 CJM. All rights reserved.
//

#import "RequestViewModel.h"

@implementation RequestViewModel

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:CrmURL]];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _sessionManager.responseSerializer.acceptableContentTypes = [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObject:@"text/plain"]];
		_sessionManager.responseSerializer.acceptableContentTypes = [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObject:@"text/html"]];
    }
    return _sessionManager;
}

- (AFHTTPSessionManager *)oldSessionManager {
    if (_oldSessionManager == nil) {
        _oldSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
        _oldSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _oldSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _oldSessionManager;
}

- (void)dealloc {

    [self.sessionManager invalidateSessionCancelingTasks:YES];
}

@end
