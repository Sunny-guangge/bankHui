//
//  BHNetworking.m
//  bankHui
//
//  Created by 王帅广 on 16/3/10.
//  Copyright © 2016年 王帅广. All rights reserved.
//

#import "BHNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFHTTPSessionManager.h"

// 项目打包上线都不会打印日志，因此可放心。
#ifdef DEBUG
#define HYBAppLog(s, ... ) NSLog( @"[%@：in line: %d]-->%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define HYBAppLog(s, ... )
#endif

static NSString *sg_privateNetworkBaseUrl = nil;
static BOOL sg_isEnableInterfaceDebug = NO;
static BOOL sg_shouldAutoEncode = NO;
static NSDictionary *sg_httpHeaders = nil;

@implementation BHNetworking


+ (void)updateBaseUrl:(NSString *)baseUrl
{
    sg_privateNetworkBaseUrl = baseUrl;
}


+ (NSString *)baseUrl
{
    return sg_privateNetworkBaseUrl;
}



+ (void)enableInterfaceDebug:(BOOL)isDebug
{
    sg_isEnableInterfaceDebug = isDebug;
}

+ (BOOL)isDebug{
    return sg_isEnableInterfaceDebug;
}

+ (void)shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
{
    sg_shouldAutoEncode = shouldAutoEncode;
}

+ (BOOL)shouldEncode{
    return sg_shouldAutoEncode;
}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders
{
    sg_httpHeaders = httpHeaders;
}



+ (BHURLSessionTask *)getWithUrl:(NSString *)url
                         success:(BHResponseSuccess)success
                            fail:(BHResponseFail)fail
{
    return [self getWithUrl:url params:nil success:success fail:fail];
}



+ (BHURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                         success:(BHResponseSuccess)success
                            fail:(BHResponseFail)fail
{
    return [self getWithUrl:url params:params progress:nil success:success fail:fail];
}

+ (BHURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                        progress:(BHGetProgress)progress
                         success:(BHResponseSuccess)success
                            fail:(BHResponseFail)fail
{
    AFHTTPSessionManager *manager = [self manager];
    
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            
            HYBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            
            return nil;
        }
    }else{
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrl] ,url]] == nil) {
            HYBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    BHURLSessionTask *session = nil;
    
    session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progress) {
            progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
    
    return session;
}


+ (BHURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(BHResponseSuccess)success
                             fail:(BHResponseFail)fail
{
    return [self postWithUrl:url params:params progress:nil success:success fail:fail];
}

+ (BHURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                         progress:(BHPostProgress)progress
                          success:(BHResponseSuccess)success
                             fail:(BHResponseFail)fail
{
    AFHTTPSessionManager *manager = [self manager];
    
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            
            HYBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            
            return nil;
        }
    }else{
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrl] ,url]] == nil) {
            HYBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    BHURLSessionTask *session = nil;
    
    session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progress) {
            progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
    
    return session;
}

+ (BHURLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                             filename:(NSString *)filename
                                 name:(NSString *)name
                             mimeType:(NSString *)mimeType
                           parameters:(NSDictionary *)parameters
                             progress:(BHUploadProgress)progress
                              success:(BHResponseSuccess)success
                                 fail:(BHResponseFail)fail
{
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            HYBAppLog(@"url无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            HYBAppLog(@"url无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    AFHTTPSessionManager *manager = [self manager];
    BHURLSessionTask *session = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
    
    return session;
}



+ (BHURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                               progress:(BHUploadProgress)progress
                                success:(BHResponseSuccess)success
                                   fail:(BHResponseFail)fail
{
    if ([NSURL URLWithString:uploadingFile] == nil) {
        HYBAppLog(@"uploadingFile无效，无法生成URL，请检查待上传文件是否存在");
        return nil;
    }
    
    NSURL *uploadURL = nil;
    
    if ([self baseUrl] == nil) {
        uploadURL = [NSURL URLWithString:url];
    }else{
        uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrl],url]];
    }
    
    if (uploadURL == nil) {
        HYBAppLog(@"url无效，无法生成URL，可能是URL中有中文或特殊字符，请尝试Encode URL");
        return nil;
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    AFHTTPSessionManager *manager = [self manager];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    
    BHURLSessionTask *session = [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (success) {
            success(responseObject);
        }
        
        if (error) {
            if (fail) {
                fail(error);
            }
        }
        
    }];
    
    
    return session;
}



+ (BHURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)path
                             progress:(BHDownloadProgress)progress
                              success:(BHResponseSuccess)success
                                 fail:(BHResponseFail)fail
{
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            HYBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }else{
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrl],url]] == nil) {
            HYBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *manager = [self manager];
    
    BHURLSessionTask *session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (success) {
            success(filePath.absoluteString);
        }
        
        if (error) {
            if (fail) {
                fail(error);
            }
        }
    }];
    
    [session resume];
    
    return session;
}

#pragma mark - Private
+ (AFHTTPSessionManager *)manager
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = nil;
    
    if ([self baseUrl] != nil) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
    }else{
        manager = [AFHTTPSessionManager manager];
    }
    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    for (NSString *key in sg_httpHeaders.allKeys) {
        if (sg_httpHeaders[key] != nil) {
            [manager.requestSerializer setValue:sg_httpHeaders[key] forHTTPHeaderField:key];
        }
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    manager.operationQueue.maxConcurrentOperationCount = 3;
    
    return manager;
}

+ (NSString *)encodeUrl:(NSString *)url {
    return [self hyb_URLEncode:url];
}

+ (NSString *)hyb_URLEncode:(NSString *)url {
    NSString *newString =
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)url,
                                                              NULL,
                                                              CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    
    return url;
}

@end
