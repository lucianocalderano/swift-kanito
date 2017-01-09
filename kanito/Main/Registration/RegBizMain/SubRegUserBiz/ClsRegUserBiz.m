
#import "ClsRegUserBiz.h"


@implementation ClsCity
@end
@implementation ClsCountry
@end
@implementation ClsActivity
@end

@implementation ClsRegUserBiz

- (instancetype) init {
    self = [super init];
    if (self) {
        self.city = [[ClsCity alloc] init];
        self.country = [[ClsCountry alloc] init];
        self.activity = [[ClsActivity alloc] init];

        self.strNome = @"";
        self.strUser = @"";
        self.strPass = @"";
        self.strMail = @"";
        self.strAddr = @"";
        self.strCap = @"";
        self.strForeignCity = @"";
    }
    return self;
}

@end
