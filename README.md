# README

Welcome to Matt Powell's Weather App

This application was written in a few days (that were also loaded with other tasks) to demonstrate my coding style and ability.

Overview
This is an interesting application because it does not use any ActiveRecord models. The vision is that the user would enter their US Zipcode, and a weather forecast 
would be displayed. I found a REST webservice from NOAA that looked like it would do the trick, so my vision is that I would call the webservice, load the resulting 
hash from the returned JSON into the cache and then my view would parse through the data and show the various aspects of the weather forecast to the user. If the same
zipcode was requested within 30 minutes, it would read the forecast from cache and display it for the user.

How Far I Got
I quickly built a form to prompt the user for their zipcode. I validated that the zipcode was five numeric digits and wrote up some test cases to verify this.
My testing was interesting because I couldn't rely on the ActiveRecord validation so ended up mimicking something similar. There is some cleaning up to do since my
fetch method and my show method ended up being almost identical as the issue solidified in my mind. I also ended up re-using the basic form on both the home page
(index method) and the show method.
The meat of the work is in the /lib/forecast.rb. I wrote a class that wraps the NOAA web service calls and the memory cache access into this class. Unfortunately,
the documentation for the web service was not great, and I started down the path of making the REST calls when I needed to pull the plug. I am confident with another
day I would be able to get it working, but I need to get a couple hours of sleep tonight before a meeting I have in the morning. NOAA has a form UI that you can set all
the parameters and it will return the XML for the forecast, so it looks like I could mimic their HTTP POSTS to get the proper results. My Web service calls were
returning HTML that displayed the syntax for the interface, so obviously something was being missed at this point...most likely by me.

What To Do Next
Obviously getting the NOAA Web Service calls to return actual XML is critical. Also, I noticed using their form interface for the web service, that it would return
an error condition if the zip code had no data. For instance, my home zipcode does not return data, but the zipcode on the other side of town works. Before going
live to the public, the app would have to handle error conditions like these gracefully and hopefully with some suggestions on how to avoid the error.
The unit test for my Forecast class still needs to be written, and it needs to test not only bad inputs but also network problems and inputs that seem legitimate,
but that the Web service has problems with.
The UI is just functional and could use some work to spiff up the usability. I did some basic work to make sure things like the error codes had classes that
could be used to make them red with a little CSS and so forth.
I haven't even gotten to the point of displaying the web service data to the user, so adding methods to pull things like the high temperature array for the coming
week from the JSON hash still needs to happen. I also believe that real time conditions aren't actually included and were part of the requirements, but it would 
probably suffice to use the projected temperatures/precipitation/cloud conditions for the next 30 minutes. Or a different endpoint/web service might be required.

I was going to use the Rails memory cache to store my weather forecasts for the different zip codes. Note that if you were in a cloud condition with multiple virtual 
services, that this would still work, you just might have multiple servers calling the Web service for the same zip codes. You could get around this by using the 
redis cache support in rails...or just live with the fact that the web service could possibly get as many calls in 30 minutes for one zip code as you have virtual servers.

I would love to chat with you about this exercise and other ideas I have about this approach. Feel free to call me at 425-256-1190 or email mattpo@live.com.