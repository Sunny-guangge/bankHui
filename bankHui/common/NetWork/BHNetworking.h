//
//  BHNetworking.h
//  bankHui
//
//  Created by 王帅广 on 16/3/10.
//  Copyright © 2016年 王帅广. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 *  下载进度
 *
 *  @param bytesRead      已经下载的大小
 *  @param totalBytesRead 文件总大小
 *  @param totalBytesExpectedToRead  还有多少需要下载
 */
typedef void (^BHDownloadProgress)(int64_t bytesRead,int64_t totalBytesRead);

typedef BHDownloadProgress BHGetProgress;
typedef BHDownloadProgress BHPostProgress;


/**
 *  上传进度
 *
 *  @param bytesWritten      已上传的大小
 *  @param totalBytesWritten 总上传大小
 */
typedef void(^BHUploadProgress)(int64_t bytesWritten,int64_t totalBytesWritten);

@class NSURLSessionTask;

//请勿直接使用NSURLSessionDataTash，以减少对第三方的依赖
//所有接口返回的类型都是基类NSURLSessionTask，若要接收返回值且处理，请转换成对应的子类类型
typedef NSURLSessionTask BHURLSessionTask;


/**
 *  请求成功的回调
 *
 *  @param response 服务器端返回的数据类型，通常是字典
 */
typedef void(^BHResponseSuccess)(id response);

/**
 *  网络响应失败的回调
 *
 *  @param error 错误信息
 */
typedef void(^BHResponseFail) (NSError *error);


/**
 *  基于AFNetworking的网络层封装类
 */
@interface BHNetworking : NSObject

/**
 *  用于指定网络请求接口的基础url 比如就是服务器的地址
 *  通常在AppDelegate中启动时就设置一次就可以，如果接口来源于多个服务器，可以调用更新
 *
 *  @param baseUrl 网络接口的基础url
 */
+ (void)updateBaseUrl:(NSString *)baseUrl;

/**
 *  对外公开可获取当前所设置的网络接口基础url
 *
 *  @return 当前基础url
 */
+ (NSString *)baseUrl;


/**
 *  开启或关闭接口打印信息
 *
 *  @param isDebug 开发期最好打开，默认是NO
 */
+ (void)enableInterfaceDebug:(BOOL)isDebug;

/**
 *  开启或关闭是否自动将URL使用UIF8编码，用于处理链接中有中文时无法请求的问题
 *
 *  @param shouldAutoEncode YSE or NO，默认为NO；
 */
+ (void)shouldAutoEncodeUrl:(BOOL)shouldAutoEncode;


/**
 *  配置公共的请求头，只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param httpHeaders 只需将与服务器商定的固定参数设置即可
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;


/**
 *  GET请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url     接口路径，如/path/getArticleList?categoryid=1
 *  @param success 接口成功请求到数据的回调
 *  @param fail    接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (BHURLSessionTask *)getWithUrl:(NSString *)url
                         success:(BHResponseSuccess)success
                            fail:(BHResponseFail)fail;


/**
 *  GET请求接口，若不能指定baseurl，可传完整的url
 *
 *  @param url     接口路径
 *  @param params  接口所需的拼接参数
 *  @param success 接口成功请求到数据的回调
 *  @param fail    接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (BHURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                         success:(BHResponseSuccess)success
                            fail:(BHResponseFail)fail;

+ (BHURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                        progress:(BHGetProgress)progress
                         success:(BHResponseSuccess)success
                            fail:(BHResponseFail)fail;


/**
 *  POST请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url     接口路径
 *  @param params  接口中所需的参数
 *  @param success 接口成功请求到数据的回调
 *  @param fail    接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (BHURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(BHResponseSuccess)success
                             fail:(BHResponseFail)fail;


+ (BHURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                         progress:(BHPostProgress)progress
                          success:(BHResponseSuccess)success
                             fail:(BHResponseFail)fail;


/**
 *  图片上传接口，若不指定baseurl，可直接传完整的url
 *
 *  @param image      图片
 *  @param url        上传图片的url
 *  @param filename   给图片起一个名字，默认为当前日期时间，格式为“yyyyMMddHHmmss”，后缀jpg
 *  @param name       与指定的图片相关联的名称，这是由后端写接口的人指定的，如imagefiles
 *  @param mimeType   默认为image/jpeg
 *  @param parameters 参数
 *  @param progress   上传进度
 *  @param success    上传成功回调
 *  @param fail       上传失败回调
 *
 *  @return
 */
+ (BHURLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                             filename:(NSString *)filename
                                 name:(NSString *)name
                             mimeType:(NSString *)mimeType
                           parameters:(NSDictionary *)parameters
                             progress:(BHUploadProgress)progress
                              success:(BHResponseSuccess)success
                                 fail:(BHResponseFail)fail;


/**
 *  上传文件
 *
 *  @param url           路径
 *  @param uploadingFile 上传文件的路径
 *  @param progress      上传进度
 *  @param success       上传成功回调
 *  @param fail          上传失败回调
 *
 *  @return
 */
+ (BHURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                               progress:(BHUploadProgress)progress
                                success:(BHResponseSuccess)success
                                   fail:(BHResponseFail)fail;


/**
 *  下载文件
 *
 *  @param url      下载路径
 *  @param path     下载存储的路径
 *  @param progress 下载进度
 *  @param success  下载成功后的回调
 *  @param fail     下载失败后的回调
 *
 *  @return
 */
+ (BHURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)path
                             progress:(BHDownloadProgress)progress
                              success:(BHResponseSuccess)success
                                 fail:(BHResponseFail)fail;

@end