//
//  ViewController.m
//  iOS Example
//
//  Created by Elf Sundae on 2019/06/19.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "ViewController.h"
#import <ESAPIClient/ESAPIClient.h>

#define CellIdentifier @"cellID"

@interface ViewController ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"ESAPIClient Example";

    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:CellIdentifier];

    self.data = @[ @"GET", @"JSON Is Not Dictionary", @"No Code Key" ];
}

- (void)GET
{
    [APIClient GET:@"users/ElfSundae" parameters:nil success:nil failure:nil];
}

- (void)JSONIsNotDictionary
{
    [APIClient GET:@"users/ElfSundae/repos" parameters:nil success:nil failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showAlert:error.localizedDescription];
    }];
}

- (void)NoCodeKey
{
    ESAPIClient *client = APIClient.copy;
    client.responseSerializer.responseCodeKey = @"code";
    [client GET:@"users/1" parameters:nil success:nil failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showAlert:error.localizedDescription];
    }];
}

- (void)showAlert:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *selectorString = [self.data[indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@""];
    SEL selector = NSSelectorFromString(selectorString);
    if ([self respondsToSelector:selector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
        invocation.selector = selector;
        [invocation invokeWithTarget:self];
    }
}

@end
