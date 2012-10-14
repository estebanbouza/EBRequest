# EBRequest

------------

## Introduction

The purpose of this library is to address two common time consuming tasks of iOS development:

* **Fetch data** easily from the network. By data this can be: images, JSON feeds, generic data, etc... The idea here is to follow the ASIHTTPRequest approach and provide completion and error blocks to be executed when the request is done.


* **Map JSON feeds to custom NSObjects easily**. The idea here is to let the library parse the JSON feeds to the classes you want. A minimum input from the developer is needed. 

The spirit of this framework is to keep it as simple as possible, with the minimum amount of the developer user needed. 


## Examples

Things you can do with this library:

* Request data easily:

		NSURL *url = [NSURL URLWithString:@"https://www.google.com/logos/2012/bohr11-hp.jpg"];

		EBDataRequest *request = [EBDataRequest requestWithURL:url];
    
    	request.completionBlock = ^(NSData *responseData) {
    		/* Use responseData */    
	    };
		
		[request start];

* The most important part: **Map JSON feeds to classes easily**. Let's say you have 2 entities in your model: `Person` and `Address`:
	* `Person`:
			
			@interface MockPerson : NSObject

			@property (nonatomic, strong)                       NSString    *name;
			@property (nonatomic, strong)                       NSNumber    *age;
			@property (nonatomic, strong)                       NSDate      *birthDate;
			@property (nonatomic, strong, getter = isEmployed)  NSNumber    *employed;
			@property (nonatomic, strong)                       MockAddress *address;
			@property (nonatomic, strong)                       NSArray     *children;
			
			@end
			
	* `Address`:
		
			@interface MockAddress : NSObject

			@property (nonatomic, strong)           NSString *street;
			@property (nonatomic, strong)           NSString *city;
			@property (nonatomic, strong)           NSString *country;
			
			@end

	* And let's say that you have a JSON feed that looks like:

			{
			  "name": "john smith",
			  "age": 32,
			  "employed": true,
			  "address": {
			    "street": "701 first ave.",
			    "city": "sunnyvale, ca 95125",
			    "country": "united states"
			  },
			  "children": [
			    {
			      "name": "richard",
			      "age": 7
			    },
			    {
			      "name": "susan",
			      "age": 4
			    }
			  ]
			}

	* Then you can map the feed to your model like this:
	
			EBJSONRequest *request = [EBJSONRequest requestWithURL:url];
				
			request.classesToMap = @[[MockPerson class], [MockAddress class]];
			    
			request.completionBlock = ^(id data){
				/* data is already mapped to your custom class! */
				
				MockPerson *john = (MockPerson *)data;
				NSLog(@"Address: %@", john.address);
				
				MockPerson *susan = [john.children objectAtIndex:1];
				NSLog(@"Susan age: %@", susan.age);
				
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


## Class documentation

Read the full class documentation at `docs/html/index.html`


