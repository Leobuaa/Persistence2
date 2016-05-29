//
//  ViewController.m
//  Persistence
//
//  Created by Leo Peng on 5/29/16.
//  Copyright © 2016 Leo Peng. All rights reserved.
//

#import "ViewController.h"
#import "FourLines.h"

static NSString * const kRootKey = @"kRootKey";

@interface ViewController ()

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *lineFields;

@end

@implementation ViewController

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingString:@"/data.archive"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        FourLines *fourlines = [unarchiver decodeObjectForKey:kRootKey];
        [unarchiver finishDecoding];
        
        for (int i = 0; i < 4; i++) {
            UITextField *theField = self.lineFields[i];
            theField.text = fourlines.lines[i];
        }
    }
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResignActive:)
     name:UIApplicationWillResignActiveNotification
     object:app];
    
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    NSString *filePath = [self dataFilePath];
    
    FourLines *fourlines = [[FourLines alloc] init];
    fourlines.lines = [self.lineFields valueForKey:@"text"];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:fourlines forKey:kRootKey];
    [archiver finishEncoding];
    bool success = [data writeToFile:filePath atomically:YES];
    if (!success) {
        NSLog(@"Failed");
    } else {
        NSLog(@"Succeed");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
