//
//  SensitiveWord.h
//  LeftEar
//
//  Created by zhixing on 2019/9/14.
//  Copyright © 2019 zhixing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterWordManager : NSObject
- (BOOL)containsFilterWord:(NSString *)str;
- (NSString *)filter:(NSString *)str;
- (void)configFilter;
- (void)releaseFilter;
@end

NS_ASSUME_NONNULL_END
