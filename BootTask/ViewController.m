//
//  ViewController.m
//  BootTask
//
//  Created by PC on 2021/8/16.
//

#import "ViewController.h"

/**
 GCD:https://www.jianshu.com/p/0ecfb0d0bc2b

 dock不显示当前程序:
                info.plist添加:
                             <key>LSUIElement</key>
                             <true/>

 */

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self runLoop];
}

- (void)loadView
{
    NSView *view = [[NSView alloc] init];
    view.frame = CGRectMake(0, 0, 0, 0);
    self.view = view;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (void)runLoop
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"task" ofType:@"plist"];
//    NSDictionary *src = [NSDictionary dictionaryWithContentsOfFile:path];
//    NSDictionary *list = src[@"list"];
//    NSArray *names = [list.allKeys sortedArrayUsingSelector:@selector(compare:)];
//
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    queue.maxConcurrentOperationCount = 1;
//    for (NSString *name in names) {
//        NSString *shellStr = list[name];
//        [queue addBarrierBlock:^{
//            [self taskWithName:name arguments:shellStr];
//
//        }];
//    }
//
//    [queue addBarrierBlock:^{
//        exit(0);
//    }];


    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_group_enter(group);//任务数 +1
    dispatch_async(queue, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"task" ofType:@"plist"];
        NSDictionary *src = [NSDictionary dictionaryWithContentsOfFile:path];
        NSDictionary *list = src[@"list"];
        NSArray *names = [list.allKeys sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *name in names) {
            NSString *shellStr = list[name];
            [self taskWithName:name arguments:shellStr];
        }
        dispatch_group_leave(group);//任务数 -1
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        exit(0);
    });

}

//使用-c, shell命令以为一个合成的字符串
//shellStr:需要执行shell命令的字符串
- (void)taskWithName:(NSString *)name  arguments:(NSString *)shellStr
{
    NSTask *certTask = [[NSTask alloc]init];
    [certTask setLaunchPath:@"/bin/bash"];
    [certTask setArguments:@[@"-c",shellStr,]];//数组中使用两个item即可

    NSPipe *pipe = [NSPipe pipe];
    [certTask setStandardOutput:pipe];
    [certTask setStandardError:pipe];
    NSFileHandle *handle = [pipe fileHandleForReading];
    [certTask launch];

    NSString *shellResult = [[NSString alloc] initWithData:[handle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    printf("%s: %s",name.UTF8String,shellResult.UTF8String);
}



@end
