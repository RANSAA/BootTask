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

    // Do any additional setup after loading the view.
    [self task];

    exit(0);
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (NSDictionary *)getShellTask
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"task" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *task = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"task:%@",task);
    [task writeToFile:@"/Users/kimi/Downloads/12.plist" atomically:YES];
    return  task;
}

- (void)task
{
//    NSDictionary *task = [self getShellTask];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"task" ofType:@"plist"];
    NSDictionary *task = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"task:%@",task);


    NSString *launchPath = task[@"launchPath"];
    NSArray *arguments = task[@"arguments"];

    NSTask *certTask = [[NSTask alloc]init];
    [certTask setLaunchPath:launchPath];
    [certTask setArguments:arguments];
    NSPipe *pipe = [NSPipe pipe];
    [certTask setStandardOutput:pipe];
    [certTask setStandardError:pipe];
    NSFileHandle *handle = [pipe fileHandleForReading];
    [certTask launch];

    NSString *shellResult = [[NSString alloc] initWithData:[handle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    NSLog(@"shellResult:%@",shellResult);
}
@end
