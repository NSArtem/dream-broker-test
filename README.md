# ios-critique

## Task Description

Implement an iOS Application which will display "N" number of images with texts in the UI as List. The images to display are located in a (free) remote server. User can give input in the UI about how many images she/he wants to display, and the App will fetch the images randomly and display them on the UI. There should be a reload/refresh option which will fetch "N" number of images randomly again and display them on the screen. The texts on images are also randomly chosen from the give URL. Finally, the list item should animate when user scrolls the list. Please refer to following sample, which demonstrate the listview and the item animation:

![](animation.gif)

To get the image URLs and the texts, we have prepared a *Fake* REST API server with one API end point:

GET http://my-json-server.typicode.com/mdislam/rest_service/data

This API end point returns a JSON response having the information about the sample image URLs and the texts to display on images. You have to generate the URLs from the JSON response and fetch the images using that generated URLs. And then choose text randomly to display on the image. The final generated URL to fetch an image looks like following:

https://sample-videos.com/img/Sample-jpg-image-100kb.jpg

OR,

https://sample-videos.com/img/Sample-png-image-100kb.png

## Summary (App Functionality)
* List of Images with texts, randomly fetch from remote server (image URLs need to be generated from the given API)
* Animate list item while scrolling
* Input field for number of images to fetch
* Reload/Refresh capability, each "reload" will randomize the images and texts

## Submission
Please submit your code by creating a pull request against the `master` branch

## Requirements
* The code should be maintainable and scalable.
* We will be happy to see some tests (i.e. Unit tests).
* Please give instructions on how to run the app and run the tests (if any)

## Please Note That
* The JSON response from the REST API server is always static.
* You are allowed to use your preferable programming language.
* It is important for us to understand your skill sets and how you write clean maintainable code.

## Deadline
We recommend spending 4 hours on this assignment, but if you need more time then you can use some more hours. Happy Coding!
