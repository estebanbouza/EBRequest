# EBRequest
**An ASIHTTPRequest like library.**

--------------

Things you can do with this library:

* Request data easily:

		NSURL *url = [NSURL URLWithString:@"https://www.google.com/logos/2012/bohr11-hp.jpg"];

		EBDataRequest *request = [EBDataRequest requestWithURL:url];
    
    	request.completionBlock = ^(NSData *responseData) {
    		/* Use responseData */    
	    };
		
		[request start];
	 

* Request JSON feeds easily:

		NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=textfromxcode"];
		
		EBJSONRequest *request = [EBJSONRequest requestWithURL:url];
    
	    request.completionBlock = ^(id data){
	    	NSArray *tweets = (NSArray *)data;
	    	
	    	for (NSDictionary *tweet in tweets) {
		    	NSLog(@"Tweet: %@", tweet);
	    	}

	    };
	    
	    [request start];

* Map JSON feeds to classes easily:





Read the class documentation inside docs/html/index.html


