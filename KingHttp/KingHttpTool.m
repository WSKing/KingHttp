//
//  KingHttpTool.m
//  CarWash
//
//  Created by wsk on 2017/9/27.
//  Copyright © 2017年 wsk. All rights reserved.
//

#import "KingHttpTool.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>
@interface KingHttpTool ()
@end

@implementation KingHttpTool

static AFHTTPSessionManager *_manager;
+ (AFHTTPSessionManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [AFHTTPSessionManager manager];
    });;
    return _manager;
}

//网络
+ (void)initialize {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
+ (BOOL)reachable {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}
+ (BOOL)reachableWWAN {
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN];
}
+ (BOOL)reachableWifi {
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
}
+ (BOOL)reachNoNet {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable;
}

//普通的数据请求
+ (void)POST:(NSString *)urlString params:(id)params success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    AFHTTPSessionManager * manager = [self shareManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    [manager POST:urlString
       parameters:params
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              success(responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failure(@"请求超时");
          }];
}

//上传图片
+ (void)UploadImages:(NSString *)urlString params:(id)params formDataName:(NSString *)formDataName images:(NSArray *)images success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [self shareManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",
                                                         @"multipart/form-data",
                                                         @"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"image/jpg",
                                                         @"application/octet-stream",
                                                         @"text/json", nil];
    
    [manager POST:urlString
       parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    for (NSInteger i = 0; i < images.count; i++) {
        UIImage *image = images[i];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@000%ld.jpg", dateString,(long)i];
        NSLog(@"%@",fileName);
        /*
         *该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        [formData appendPartWithFileData:imageData name:formDataName fileName:fileName mimeType:@"image/jpeg"];
    }
    } progress:^(NSProgress * _Nonnull uploadProgress) {

} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    success(responseObject);
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failure(error.localizedDescription);
    
}];

}

//上传视频和封面
+ (void)UpLoadVideo:(NSString *)urlString paramas:(id)params fileName:(NSString *)fileName video:(NSString *)videoPath image:(UIImage *)coverImage progress:(void(^)(CGFloat progress))progress success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    AFHTTPSessionManager * manager = [KingHttpTool shareManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",
                                                         @"multipart/form-data",
                                                         @"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"image/jpg",
                                                         @"application/octet-stream",
                                                         @"text/json", nil];
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //视频文件
        NSData *data = [NSData dataWithContentsOfFile:videoPath];
        [formData appendPartWithFileData:data name:fileName fileName:@"video.mp4" mimeType:@"video/mp4"];
        
        //图片文件
        NSData *imageData = UIImageJPEGRepresentation(coverImage, 0.3);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
        [formData appendPartWithFileData:imageData name:@"video_img" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}



@end
