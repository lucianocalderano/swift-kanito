
#import "SubRegUserBiz.h"

@interface SubRegUserBiz () {
    IBOutlet UIView *viewNome;
    IBOutlet UIView *viewMail;
    IBOutlet UIView *viewUser;
    IBOutlet UIView *viewPass;
    IBOutlet UIView *viewCap;
    IBOutlet UIView *viewAddr;

    IBOutlet MyTextField *txtNome;
    IBOutlet MyTextField *txtMail;
    IBOutlet MyTextField *txtUser;
    IBOutlet MyTextField *txtPass;
    IBOutlet MyTextField *txtAddr;
    IBOutlet MyTextField *txtCap;
    ClsRegUserBiz *clsRegUserBiz;
}
@end

@implementation SubRegUserBiz

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    txtNome.placeholder = keyLang(@"regUserBiz.Name");
    txtUser.placeholder = keyLang(@"regUserBiz.User");
    txtPass.placeholder = keyLang(@"regUserBiz.Pass");
    txtMail.placeholder = keyLang(@"regUserBiz.Mail");
    txtCap.placeholder = keyLang(@"regUserBiz.Cap");
    txtAddr.placeholder = keyLang(@"regUserBiz.Addr");

    [self updateAllViews];
    
    for (NSInteger i = 101; i < 104; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i];
        btn.layer.cornerRadius = 5;
    }
    UITapGestureRecognizer *tap;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnCity:)];
    [self.lblCity addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnCountry:)];
    [self.lblCountry addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnActivities:)];
    [self.lblActivities addGestureRecognizer:tap];
}

- (void) updateAllViews {
    [self updateView:viewNome];
    [self updateView:viewMail];
    [self updateView:viewUser];
    [self updateView:viewPass];
    [self updateView:viewAddr];
    [self updateView:viewCap];
}

- (void) updateView:(UIView *) view {
    view.layer.cornerRadius = 10;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1;
}

- (BOOL)validateEmailWithString:(NSString*)email {
    NSString *strMatch = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strMatch];
    return [strTest evaluateWithObject:email];
}

- (BOOL)validateUserWithString:(NSString*)strUser {
    NSString *strMatch = @"[A-Za-z0-9]{3,20}";
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strMatch];
    return [strTest evaluateWithObject:strUser];
}

#pragma mark -

- (BOOL) checkUserData {
    [self updateAllViews];
    clsRegUserBiz.strNome = [txtNome.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (clsRegUserBiz.strNome.length == 0) {
        viewNome.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [txtNome becomeFirstResponder];
        return NO;
    }
    clsRegUserBiz.strMail = [txtMail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ((clsRegUserBiz.strMail.length == 0) || ([self validateEmailWithString:clsRegUserBiz.strMail] == NO )) {
        viewMail.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [txtMail becomeFirstResponder];
        return NO;
    }
    clsRegUserBiz.strUser = [txtUser.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ((clsRegUserBiz.strUser.length == 0) || ([self validateUserWithString:clsRegUserBiz.strUser] == NO )) {
        viewUser.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [txtUser becomeFirstResponder];
        return NO;
    }
    clsRegUserBiz.strPass = [txtPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (clsRegUserBiz.strPass.length == 0) {
        viewPass.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [txtPass becomeFirstResponder];
        return NO;
    }
    clsRegUserBiz.strAddr = [txtAddr.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (clsRegUserBiz.strAddr.length == 0) {
        viewAddr.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [txtAddr becomeFirstResponder];
        return NO;
    }
    clsRegUserBiz.strCap = [txtCap.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (clsRegUserBiz.strCap.length == 0) {
        viewCap.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [txtCap becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)btnCity:(id)sender {
    [self.delegate exitSubRegUserBiz:regUserBiz_Region];
}

- (IBAction)btnCountry:(id)sender {
    [self.delegate exitSubRegUserBiz:regUserBiz_Country];
}

- (IBAction)btnActivities:(id)sender {
    [self.delegate exitSubRegUserBiz:regUserBiz_Activities];
}
@end
