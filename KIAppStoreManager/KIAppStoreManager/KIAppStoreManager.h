//
//  KIAppStoreManager.h
//  Kitalker
//
//  Created by 杨 烽 on 14-4-16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KIAppStoreManager : NSObject

/*检查新版本*/
- (void)checkVersionWithAppID:(NSString *)appID showNewestMsg:(BOOL)showMsg;

@end
