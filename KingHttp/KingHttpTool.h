//
//  KingHttpTool.h
//  CarWash
//
//  Created by wsk on 2017/9/27.
//  Copyright © 2017年 wsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KingHttpTool : NSObject
+ (BOOL)reachable;
+ (BOOL)reachableWifi;
+ (BOOL)reachableWWAN;
+ (BOOL)reachNoNet;


/**
 post请求

 @param urlString url
 @param params 参数
 @param success 成功回调block
 @param failure 失败回调block
 */
+ (void)POST:(NSString *)urlString
      params:(id)params
     success:(void(^)(id responseObject))success
     failure:(void (^)(NSString *errorMsg))failure;


/**
 上传图片

 @param urlString url
 @param params 参数
 @param formDataName formData名
 @param images 要上传的图片(数组)
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)UploadImages:(NSString *)urlString
              params:(id)params
        formDataName:(NSString *)formDataName
              images:(NSArray *)images
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSString *errorMsg))failure;



/**
 上传视频

 @param urlString url
 @param params 参数
 @param fileName fileName名
 @param videoPath 视频路径
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)UpLoadVideo:(NSString *)urlString
            paramas:(id)params
       fileName:(NSString *)fileName
              video:(NSString *)videoPath
              image:(UIImage *)coverImage
           progress:(void(^)(CGFloat progress))progress
            success:(void(^)(id responseObject))success
            failure:(void(^)(NSString *errorMsg))failure;
@end
