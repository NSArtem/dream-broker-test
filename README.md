# ios-critique

## Task Description

Implement an iOS/Android Application which will display "N" number of images in the UI as List. The images to display are located in a (free) remote server. User can give input in the UI about how many images she/he wants to display, and the App will fetch the images randomly and display them on the UI. There should be a reload/refresh option which will fetch "N" number of images randomly again and display them on the screen.

To get the image URLs, we have prepared a *Fake* REST API server with one API end point:

GET http://my-json-server.typicode.com/mdislam/rest_service/data

This API end point returns a JSON response having the information about the sample image URLs. You have to generate the URLs from the JSON response and fetch the images using that generated URLs. The URL to fetch an image looks like following:

https://sample-videos.com/img/Sample-jpg-image-100kb.jpg

OR,

https://sample-videos.com/img/Sample-png-image-100kb.png


## Animate the Image list

Animate each list item when user scrolls the image-list according to the following animation:

![](animation.gif)

**Note:** you may freely choose your own animation instead of the given one, to animate each list item while scrolling the listView.

## Requirements
* The code should be maintainable and scalable.
* We will be happy to see some tests (i.e. Unit tests).
* Showcase at least one Animation skill in this application.

## Please Note That
* The JSON response from the REST API server is always static.
* You are allowed to use your preferable programming language.
* It is important for us to understand your skill sets and how you write code. Therefore, it is OK if you aren’t able to finish all the tasks.

## Deadline
We recommend spending 4 hours on this assignment, but if you need more time then you can use some more hours. Happy Coding!
