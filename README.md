# B_APP

This is an App for blind and visually impaired people. 
It tells you points of interest based on your location enabelling them to explore the world around them.

## To Do

- The iPhone recognises if it is dropped and sends a signal tone and/or flashes

- Calculate the distance to the objects near you based on their and your position

- ViewController aufräumen

- Gitignore for API Key

## Ideas

- The iPhone recognises if it is dropped and sends a signal tone and/or flashes

- While a POI is put into Speech, the volume adjusts according to how close you are to the POI with your active input parameters (scan-range, direction)

- PlacesAPI_RequestManagement
  - Initially the phone pulls POI's with a greatere range than the App actually displays. 
  So you have two circles: an inner circle of displayed POI's and an outher circle with all the POI's pulled from the server.
  A new POI-request will be made if the inner circle crosses the outher circle. (not unlimited available requests)
  =>POI Data is only requested if you are leaving the downloaded range

## Output Algorithm Rules
-Only one String/POI at the time is selected to be put into speech
-If there are more than one POI's in your scan field, the closest one will be outputet first
-The scan-field which POI's are put into speech is pizza-sliece shaped
-Every POI that is put into speech completely, is saved as read and will not be repeated until:

-Not sure if it is better if a POI gets outputet as soon as the input parameters match. The consequce would be that speech has to be able to be aborted so that ther is not outdated information being put inito speech when you are acctally pointing in a different direction.
  -Something that is being said should never be aborted
  -Nothing should start to be put into speech if the parameters are changeing at a cecrtain rate (direction, location, scan-range


