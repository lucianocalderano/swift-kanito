
#import "ClsFotoUpld.h"
#import "MyHttp.h"

@implementation ClsFotoUpld

static NSInteger numUpload = 0;

- (void) uploadArrayOfPicsInBackground:(NSArray *) arrDat DicPost:(NSDictionary *) dic{
    numUpload += arrDat.count;
    for (NSData *dat in arrDat)
        [self uploadFotoInBackground:dic ImageData:dat];

}

- (void) uploadFotoInBackground:(NSDictionary *)dicPostData ImageData:(NSData *)datImg {
    NSString *urlString = [defServerPvt stringByAppendingPathComponent:@"add-new-photo-to-album"];
    NSURL *postURL = [NSURL URLWithString:urlString];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:dicPostData];
    dic[@"auth_code"] = defKeyPvt;
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    postRequest.HTTPMethod = @"POST";
    NSString *stringBoundary = @"--Lc--Post--";
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [postRequest addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    for (NSString *strKey in dic.allKeys) {
        NSString *s =[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",
                      stringBoundary, strKey, dic[strKey]];
        [postBody appendData:[s dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"upload.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/jpg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[NSData dataWithData:datImg]];
    [postBody appendData:datImg];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    postRequest.HTTPBody = postBody;

    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest
                                     completionHandler:^(NSData *data,
                                                         NSURLResponse *response,
                                                         NSError *error) {
                                         [self httpResponse:data response:response error:error];                                         
                                     }] resume];
}

- (void) httpResponse:(NSData *)data response:(NSURLResponse *)response error:(NSError *)err {
    numUpload--;
    
    if (err.code > 0) {
        [self showMessage:err.localizedDescription];

        return;
    }
    NSDictionary *dicResp = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
    if (err.code > 0) {
        [self showMessage:err.localizedDescription];
        return;
    }
    
    if ([dicResp[@"status"] integerValue] != 1) {
        [self showMessage:[dicResp getString:@"error_msg"]];
        return;
    }

    if (numUpload > 0)
        return;
    [self showMessage:@"Upload complete"];
}

- (void) showMessage:(NSString *) msg {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    v.backgroundColor = [MyColor myGreyLight];
    v.layer.cornerRadius = 10;
    v.layer.borderColor = [MyColor myGreyDark].CGColor;
    v.layer.borderWidth = 4;
    v.center = window.center;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 280, 50)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.numberOfLines = 2;
    lbl.font = [MyFont fontSize:24];
    lbl.textColor = [MyColor myOrange];
    lbl.text = msg;
    [v addSubview:lbl];
    [window addSubview:v];
    
    [UIView animateWithDuration:1.5
                     animations:^{
                         v.alpha = 0.95;
                     }
                     completion:^(BOOL fine) {
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              v.alpha = 0;
                                          }
                                          completion:^(BOOL fine) {
                                          }];
                     }];
    
}

@end
