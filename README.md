# B_APP

B_APP is an App for blind and visually impaired people.
It points you in the direction of POIs (points of interest) by using your location and the compass using the Google Places API.
The goal of this app is to enable blind and visually impaired people to explore the world around them.

## New Algorithm To-Do list

- [X] Getting poi data
- [X] Making an array of the same type of elements
    - [X] with the following structure:
        - distance
        - angle
        - title
    - [X] calculate the distance between the coordinates
    - [ ] calculate the angle
    - [X] put it in the variables
- [ ] Get the elements within the certain angle bounds.
- [ ] Sort the elements for the smallest distance
- [X] Output the elements


## To Do

- The iPhone recognises if it is dropped and sends a signal tone and maybe flashes

- Calculate the distance to the objects near you based on their and your position

- refactor ViewController 

- Gitignore for API Key

- Two stages of change recognition when inputs change

    - first stage: filter micromovements
    - second stage: margin for code efficiency
    
 - attribute to POI when it leaves field and when it enterrs

## Link to google docs
https://developers.google.com/places/web-service/search

## What information should be outputed:

- Name of POI
- Distance to POI
- (maybe description)


## Output Algorithm Rules

- Only one String/POI at the time is selected to be put into speech
- If there are more than one POIs in your scan-field, the closest one will be mentioned first
- The scan-field, in which POI's are mentioned, is a section of a circle, with a fixed radius and angle
- Every POI that is completely spoken, is marked as "read" and will not be repeated or interrupted except under special cirumstances like the following:
    - ...
    - ...
    
- Not sure if it is better if a POI gets output as soon as the input parameters match or not. The consequence would be that speech has to be able to be aborted so that ther is not relying on outdated information.
  - Something that is being said should never be aborted, or maybe a destinctive sound may indicate an abortion.
  - Nothing should start to be said if the parameters are changing at a certain rate (direction, location, scan-range...)

## Algorithm

```.swift
ViewDidLoad {
get_POI(coordinates)
    save POI's sorted according to distance "allPOI"

    create list with POI's in scanRange from all POI's downloaded "ScanRangePOI"
    create list with POI's in Pizza-sliced-scan-area from POI-list within sccanRange "ScanAreaPOI"
}

DidUpdateLocation {
    getGpsPosition() = coordinates
    
    if (max scan-rance > already downloaded POI-radius) {
        get_POI(coordinates)
        save POI's sorted according to distance "allPOI"

        create/update list with POI's in scanRange from all POI's downloaded "ScanRangePOI"
        create/update list with POI's in Pizza-sliced-scan-area from POI-list within sccanRange "ScanAreaPOI"
    }
    
    if (coordiantes-lastLocation > 10m) {
        update list with POI's in scanRange from all POI's downloaded "ScanRangePOI"        
        update list with POI's in Pizza-sliced-scan-area from POI-list within sccanRange "ScanAreaPOI"
    }
}

DidUpdateCompass {
    getCompas() = 2D_heading ///calculate 2D Vector
    
    if (2D_heading-lastHeading > 3°) {    
        update list with POI's in Pizza-sliced-scan-area from POI-list within sccanRange "ScanAreaPOI"
        
        check if POI's on list "spokenPOI" are still on list "ScacnAreaPOI"
        =>if not, remove from list "spokenPOI"
        
        changedInput()
        
        2D_heading = lastHeading
    }
    
}

DidUpdateTouch {
    getTouch() = scanRange ///calculate desired scan-range from touch height
    
    if (scanRange-lastScanRange > 10m) {
        update list with POI's in scanRange from all POI's downloaded "ScanRangePOI"
        update list with POI's in Pizza-sliced-scan-area from POI-list within sccanRange "ScanAreaPOI"
        
        check if POI's on list "spokenPOI" are still on list "ScacnAreaPOI"
        =>if not, remove from list "spokenPOI"
        
        changedInput()
        
        scanRange = lastScanRange
    }
}

changedInput() {
    if (POI's in desired scan-area) {
    
    speak() !!!not necessary if speak() is a loop 
    }
    
    else {
    speak("non POI's near you")
    }
}

speak() / loop {
    pick nearest POI
    convert nearest POI into text
    save poi as read on list "spokenPOI"
    
    goto next POI on list, but ignore read
}

```

## Ideas

- Use some routing technology from either Google Maps or Apple to tell the user where to turn and stuff.

- Figure out when to use the route information and when to 

- While a POI is put into Speech, the volume adjusts according to how close you are to the POI with your active input parameters (scan-range, direction)

- PlacesAPI_RequestManagement
  - Initially the phone pulls POI's with a greatere range than the App actually displays. 
  So you have two circles: an inner circle of displayed POI's and an outher circle with all the POI's pulled from the server.
  A new POI-request will be made if the inner circle crosses the outher circle. (not unlimited available requests)
  =>POI Data is only requested if you are leaving the downloaded range
