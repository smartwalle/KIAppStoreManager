//
//  KIAppStoreManager.m
//  Kitalker
//
//  Created by 杨 烽 on 14-4-16.
//
//

#import "KIAppStoreManager.h"

#define kCheckAppVersionTag 20001

@interface KIAppStoreManager () <UIAlertViewDelegate>
@property (nonatomic, copy) NSString *appId;
@end

@implementation KIAppStoreManager

- (void)checkVersionWithAppID:(NSString *)appID showNewestMsg:(BOOL)showMsg {
    if (appID != nil
        && [appID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        
        [self setAppId:appID];
        
        NSString *urlPath = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appID];
        NSURL *url = [NSURL URLWithString:urlPath];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        __weak KIAppStoreManager *weakSelf = self;
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if ([data length]>0 && !error ) {
                NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSDictionary *result = nil;
                NSArray *results = [appInfo valueForKey:@"results"];
                if (results != nil && results.count > 0) {
                    result = [results objectAtIndex:0];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *versionsInAppStore = [result valueForKey:@"version"];
                    if (versionsInAppStore) {
                        NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                        if ([bundleVersion compare:versionsInAppStore options:NSNumericSearch] == NSOrderedAscending) {
                            [weakSelf showAlertWithAppStoreVersion:versionsInAppStore
                                                           appleID:appID
                                                       description:[result valueForKey:@"description"]
                                                        updateInfo:[result valueForKey:@"releaseNotes"]];
                        } else {
                            if (showMsg) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                                                    message:NSLocalizedString(@"当前应用已为最新版本。", nil)
                                                                                   delegate:weakSelf
                                                                          cancelButtonTitle:NSLocalizedString(@"好的", nil)
                                                                          otherButtonTitles:nil];
                                [alertView show];
                            }
                        }
                    } else {
                    }
                });
            }
        }];
    }
}

- (void)showAlertWithAppStoreVersion:(NSString *)appStoreVersion appleID:(NSString *)appleID description:(NSString *)description updateInfo:(NSString *)updateInfo {
    //    NSString *message = [NSString stringWithFormat:@"内容介绍:\n%@\n\n更新内容:\n%@", description, updateInfo];
    NSString *message = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"更新内容:", nil), updateInfo];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"当前应用有新版本可以下载，是否前往更新？", nil)
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                              otherButtonTitles:NSLocalizedString(@"更新", nil), nil];
    [alertView setTag:kCheckAppVersionTag];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kCheckAppVersionTag) {
        switch ( buttonIndex ) {
            case 0:{
            }
                break;
            case 1:{
                NSString *urlPath = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", self.appId];
                NSURL *url = [NSURL URLWithString:urlPath];
                [[UIApplication sharedApplication] openURL:url];
            }
                break;
            default:
                break;
        }
    }
}

- (void)dealloc {
    _appId = nil;
}

/*检查新版本  结束*/

@end
