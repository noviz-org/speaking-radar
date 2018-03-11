# B_APP

This is an App for blind and visually impaired people.
It outputs POI's (points of interest) based on your location, the direction your phone is pointing and scan-distance as an input varriable, enabelling one to explore the world around.


## To Do

- The iPhone recognises if it is dropped and sends a signal tone and/or flashes

- Calculate the distance to the objects near you based on their and your position

- refactor ViewController 

- Gitignore for API Key

- Two stages of change recognition when inputs change

    - first stage: filter micromovements
    - second stage: margin for code efficiency
    
 - attribute to POI when it leaves field and when it enterrs


## What information should be outputed:

- Name of POI
- Distance to POI
- (maybe description)


## Output Algorithm Rules

- Only one String/POI at the time is selected to be put into speech
- If there are more than one POI in your scan-field, the closest one will be outputet first
- The scan-field which POI's are put into speech is pizza-sliece shaped and the scan-angle is fixed
- Every POI that is put into speech completely, is saved as "read" and will not be repeated until:...
    - ...
    - ...
    
- Not sure if it is better if a POI gets outputet as soon as the input parameters match. The consequence would be that speech has to be able to be aborted so that ther is not outdated information being put inito speech when you are acctally pointing in a different direction.
  - Something that is being said should never be aborted
  - Nothing should start to be put into speech if the parameters are changeing at a cecrtain rate (direction, location, scan-range

## Algorithm

```
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

- The iPhone recognises if it is dropped and sends a signal tone and/or flashes

- While a POI is put into Speech, the volume adjusts according to how close you are to the POI with your active input parameters (scan-range, direction)

- PlacesAPI_RequestManagement
  - Initially the phone pulls POI's with a greatere range than the App actually displays. 
  So you have two circles: an inner circle of displayed POI's and an outher circle with all the POI's pulled from the server.
  A new POI-request will be made if the inner circle crosses the outher circle. (not unlimited available requests)
  =>POI Data is only requested if you are leaving the downloaded range
