//
//  ViewController.m
//  BootTask
//
//  Created by PC on 2021/8/16.
//

#import "ViewController.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self taskc];

    exit(0);
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


//使用-c, shell命令以为一个合成的字符串
//shellStr:需要执行shell命令的字符串
- (void)taskc
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"task" ofType:@"plist"];
    NSDictionary *src = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *shellStr = src[@"shell"];

    NSTask *certTask = [[NSTask alloc]init];
    [certTask setLaunchPath:@"/bin/bash"];
    [certTask setArguments:@[@"-c",shellStr,]];//数组中使用两个item即可

    NSPipe *pipe = [NSPipe pipe];
    [certTask setStandardOutput:pipe];
    [certTask setStandardError:pipe];
    NSFileHandle *handle = [pipe fileHandleForReading];
    [certTask launch];

    NSString *shellResult = [[NSString alloc] initWithData:[handle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    NSLog(@"shellResult:%@",shellResult);
}



@end
