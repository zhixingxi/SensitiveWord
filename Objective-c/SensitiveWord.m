//
//  SensitiveWord.m
//  LeftEar
//
//  Created by zhixing on 2019/9/14.
//  Copyright © 2019 zhixing. All rights reserved.
//

#import "SensitiveWord.h"

@implementation SensitiveWord

/*
 * 加载本地的敏感词库
 *
 * @params filepath 敏感词文件的路径
 *
 */
- (void)initFilter {
    
    self.rootMap = [NSMutableDictionary dictionary];
    NSMutableArray *rootArray = [NSMutableArray array];
    NSURL *keywordURL = WordFilterManager.shared.keywordURL;
    NSString *fileString;
    fileString = [NSString stringWithContentsOfURL:keywordURL encoding:NSUTF8StringEncoding error:nil];
    if (fileString == nil || fileString.length == 0) {
        fileString = [[NSString alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"filterWord" ofType:@""] encoding:NSUTF8StringEncoding error:nil];
    }
    [rootArray addObjectsFromArray:[fileString componentsSeparatedByString:@"\n"]];
    
    for (NSString *str in rootArray) {
        //插入字符，构造节点
        [self insertWords:str];
    }
}

- (void)insertWords:(NSString *)words{
    NSMutableDictionary *node = self.rootMap;
    
    for (int i = 0; i < words.length; i ++) {
        NSString *word = [words substringWithRange:NSMakeRange(i, 1)];
        if (node[word] == nil) {
            node[word] = [NSMutableDictionary dictionary];
        }
        node = node[word];
    }
    
    //敏感词最后一个字符标识
    node[EXIST] = [NSNumber numberWithInt:1];
}

#pragma mark-将文本中含有的敏感词进行替换
/*
 * 将文本中含有的敏感词进行替换
 *
 * @params str 文本字符串
 *
 * @return 过滤完敏感词之后的文本
 *
 */
- (NSString *)filter:(NSString *)str{
    
    if (!self.rootMap) {
        return str;
    }
    
    NSMutableString *result = result = [str mutableCopy];
    
    for (int i = 0; i < str.length; i ++) {
        NSString *subString = [str substringFromIndex:i];
        NSMutableDictionary *node = [self.rootMap mutableCopy] ;
        int num = 0;
        
        for (int j = 0; j < subString.length; j ++) {
            NSString *word = [subString substringWithRange:NSMakeRange(j, 1)];
            
            if (node[word] == nil) {
                break;
            }else{
                num ++;
                node = node[word];
            }
            //敏感词匹配成功
            if ([node[EXIST]integerValue] == 1) {
                NSMutableString *symbolStr = [NSMutableString string];
                for (int k = 0; k < num; k ++) {
                    [symbolStr appendString:@"*"];
                }
                [result replaceCharactersInRange:NSMakeRange(i, num) withString:symbolStr];
                i += j;
                break;
            }
        }
    }
    
    return result;
}

- (BOOL)containsFilterWord:(NSString *)str {
    if (!self.rootMap) {
        return NO;
    }
    for (int i = 0; i < str.length; i ++) {
        NSString *subString = [str substringFromIndex:i];
        NSMutableDictionary *node = [self.rootMap mutableCopy] ;
        int num = 0;
        for (int j = 0; j < subString.length; j ++) {
            NSString *word = [subString substringWithRange:NSMakeRange(j, 1)];
            
            if (node[word] == nil) {
                break;
            }else{
                num ++;
                node = node[word];
            }
            //敏感词匹配成功
            if ([node[EXIST]integerValue] == 1) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)configFilter {
    if (!self.rootMap) {
        [self initFilter];
    }
}

- (void)releaseFilter {
    self.rootMap = nil;
}


@end
