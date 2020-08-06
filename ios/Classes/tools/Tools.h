#import <Foundation/Foundation.h>

@interface Tools : NSObject

//Log
+ (void)log:(id)props;

//返回标识信息
+ (NSString *)resultInfo:(NSString *)info;

// 沙盒是否有指定路径文件夹或文件
+(BOOL)isDirectoryExist:(NSString *)path;

// 是否是文件夹
+ (BOOL) isDirectory:(NSString *)path;

@end