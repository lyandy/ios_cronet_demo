//
//  ViewController.m
//  ios_cronet_demo
//
//  Created by 李扬 on 2023/8/31.
//

#import "ViewController.h"
#import <Cronet/Cronet.h>
#import <Network/Network.h>
#import <WebKit/WebKit.h>

@interface ViewController ()<NSURLSessionTaskDelegate>

@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) WKWebView *webview;

@end

@implementation ViewController

- (void)viewDidLoad {
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
    for (NSURLSessionTaskTransactionMetrics * m in metrics.transactionMetrics){
        NSLog(@"networkProtocolName %@ %@", m.networkProtocolName, @(m.resourceFetchType).stringValue);
        self.protocolLabel.text = [(m.networkProtocolName ?: @"") stringByAppendingFormat:@"  %@", @(m.resourceFetchType).stringValue];
        if(m.networkProtocolName.length > 0){
            break;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startNSURLSession];
//    [self startNSURLConnection];
}

- (void)startNSURLSession {
    if (self.session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [Cronet installIntoSessionConfiguration:config];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    //    session.sessionDescription = @"test http3";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://h2o.examp1e.net?t=" stringByAppendingString:@([[NSDate date] timeIntervalSince1970]).stringValue]]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://www.facebook.com?t=" stringByAppendingString:@([[NSDate date] timeIntervalSince1970]).stringValue]]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://maimai.cn?t=" stringByAppendingString:@([[NSDate date] timeIntervalSince1970]).stringValue]]];
    request.assumesHTTP3Capable = NO;
    //    [request setValue:@"xxxxxxxx" forHTTPHeaderField:@"User-Agent"];
    //
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *resp, __unused NSError *err) {
        NSLog(@"");
    }];
    
    [task resume];
}

- (void)startNSURLConnection {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://h2o.examp1e.net?t=" stringByAppendingString:@([[NSDate date] timeIntervalSince1970]).stringValue]]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSLog(@"%@",connectionError);
    }];
}

@end
