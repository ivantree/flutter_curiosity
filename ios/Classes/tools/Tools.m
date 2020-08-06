#import "Tools.h"
#define fileManager [NSFileManager defaultManager]
@implementation Tools

//Log
+ (void)log:(id)info{
    NSLog(@"CuriosityLog = %@", info);
}

+ (NSString *)resultInfo:(NSString *)info{
    return [NSString stringWithFormat:@"Curiosity:%@",info];
}

// 沙盒是否有指定路径文件夹或文件
+(BOOL)isDirectoryExist:(NSString *)path {
    return [fileManager fileExistsAtPath:path];
}
// 是否是文件夹
+ (BOOL) isDirectory:(NSString *)path{
    BOOL isDir = NO;
    [fileManager fileExistsAtPath:path isDirectory:&isDir];
    return isDir;
}
@end