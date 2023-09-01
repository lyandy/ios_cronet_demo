//
//  AppDelegate.m
//  ios_cronet_demo
//
//  Created by 李扬 on 2023/8/31.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 设置 支持 HTTP2, 如果设置为 NO，如果协议不支持H3，会降级到H1.1
    [Cronet setHttp2Enabled:YES];
    // 设置支持 QUIC
    [Cronet setQuicEnabled:YES];
    // 设置支持 Br 压缩算法，并列的有gzip算法
    [Cronet setBrotliEnabled:YES];
    // 设置 AcceptLanguages，AFN会自动补全设置，建议不单独设置
//    [Cronet setAcceptLanguages:@"en-US,en"];

    // 设置 请求的 UserAgent, AFN会自动补全设置，建议不单独设置
    // 这是设置生效顺序 URLRequest > Cronet > 默认
//    [Cronet setUserAgent:@"Dummy/1.0" partial:NO];

    // 设置 HTTP Cache 类型，建议不手动指定
//    [Cronet setHttpCacheType:CRNHttpCacheTypeDisabled];
    
    // 开启 metric 性能统计
    [Cronet setMetricsEnabled:YES];
    
    // 预先告诉 Cronet，支持 H3 的域名，以便尽快链接H3协议
    [Cronet addQuicHint:@"h2o.examp1e.net" port:443 altPort:443];

    // 开始cronet
    [Cronet start];

    // 建议不开启，开启后也会拦截所有的 NSURLConnection
    // 开启后，也会对webkit加载进行拦截。
//    [Cronet registerHttpProtocolHandler];

    // 是否要使用 Cronet 拦截指定请求
    // 不写的话，会拦截所有请求。最好是根据自己的条件来拦截
    [Cronet setRequestFilterBlock:^BOOL(NSURLRequest* request) {
        return YES;
    }];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
