#import "SquareDecomposer.h"

@implementation SquareDecomposer
- (NSArray <NSNumber*>*)decomposeNumber:(NSNumber*)number {
    long curent = number.longValue;
    long long target = curent * curent;
    
    NSMutableArray *totalResult = [self perfectSquareSearch: curent target: target];
    [totalResult removeLastObject];
    return totalResult.copy;
}

- (NSMutableArray <NSNumber*>*)perfectSquareSearch:(long)curent target:(long long) target {
    
    if (target == 0) {
        return @[@(curent)].mutableCopy;
    }
    
    for (long i = curent - 1; i > 0; i--) {
        long long newTarget = target - i * i;
        if (newTarget >= 0) {
            
            NSMutableArray *newResult = [self perfectSquareSearch: i target: newTarget];
            
            if (newResult) {
                [newResult addObject: @(curent)];
                return newResult;
            }
        }
    }
    
    return nil;
}

@end
