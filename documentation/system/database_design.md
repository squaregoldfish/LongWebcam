% LongWebcam Database Design

This document lists the structure of all the tables in the LongWebcam databases, as generated through the Rails migrations.
The types are Rails types, not those used by MySQL.

## Main Website database
The main database which backs the website.

### accounts
Keeps account details of external services used by the site.

Field Name        Type           Description
-----------       ------         ----------------
account           string         The name of the service
username          string         The username for the account
password          string         The password for the account
api_key           string         The API Key for the account
url               string         The root URL of the service
path              string         The path portion of the URL for a specifc service

### camera_details
Details about each camera, which may change over time.

Field Name        Type           Description
-----------       ------         ----------------
camera_id         integer        The main Camera ID
details_date      date           The date on which this set of details applied to the camera
longitude         float          The longitude of the camera's position
latitude          float          The latitude of the camera's position
bearing           integer        The direction, in degrees, in which the camera is facing
ground_height     integer        The elevation of the ground at the camera's location
camera_height     integer        The height above ground at which the camera is mounted
manufacturer      string         The manufacturer of the camera
model             string         The camera model
resolution_x      integer        The horizontal resolution of pictures taken by the camera
resolution_y      integer        The vertical resolution of pictures taken by the camera
timezone_id       string         The name of the time zone that the camera is in
daylight_saving   boolean        Indicates whether or not daylight savings time is in effect
utc_offset        integer        The UTC offset of the timezone in which the camera is located
download_start    integer        The hour of the day which denotes the start of the download window
download_end      integer        The hour of the day which denotes the end of the download window

For URL-based cameras, the system will attempt to download an image at some point between the download_start and download_end hours.

### camera_tags
The set of tags that can be applied to cameras. The tags are heirarchical.

Field Name        Type           Description
-----------       ------         ----------------
tag               string         The tag name
parent            integer        The ID of the tag's parent

### cameras
Basic details of the registered cameras

Field Name        Type           Description
-----------       ------         ----------------
owner             integer        The ID of the user account of the camera's owner
camera_type       integer        The camera type^1^
url               string         For URL_TYPE cameras, the URL from which images are downloaded
serial_number     string         The serial number of the camera (for Long Webcam cameras)
test_camera       boolean        If true, this is a test camera that is not visible to most users
licence           string         The licence under which the images from this camera are published
upload_code       string(4)      The 4-digit security code that must be used when uploading images for the camera
watermark         boolean        Indicates whether or not a watermark should be applied to published images
title             string         The camera's title
description       string         The detailed description of the camera

^1^The camera type is one of the following:

Code  Value                Description
----  -------------------  ----------------
1     URL_TYPE             Images are downloaded from a URL
2     NET_CONNECTED_TYPE   Images come from a camera that has a net connection
3     STANDALONE_TYPE      Images are stored in the camera and retrieved/uploaded manually

### cameras_events
Link table between cameras and events

Field Name        Type           Description
-----------       ------         ----------------
camera_id         integer        The camera ID
event_id          integer        The event ID

### cameras_tags
Link table between cameras and tags

Field Name        Type           Description
-----------       ------         ----------------
camera_id         integer        The camera ID
tag_id            integer        The event ID

### event_tags
The set of tags that can be applied to events. The tags are heirarchical.

Field Name        Type           Description
-----------       ------         ----------------
tag               string         The tag name
parent            integer        The ID of the tag's parent

### event_urls
Details of web pages related to recorded events

Field Name        Type           Description
-----------       ------         ----------------
title             string         The title of the web page
url               string         The URL of the web page
accessible        boolean        Is the URL accessible
last_check_date   date           The date when the URL was last checked
last_access_date  date           The date when the URL was last successfully accessed
archive_url       string         The URL stored in an archive service e.g. waybackmachine

### events
Basic details of events

Field Name            Type           Description
-----------           ------         ----------------
name                  string         The name of the event
description           string         A description of the event
description_source    string         The source of the description
start_date            date           The date on which the event started
end_date              date           The date on which the event ended

### events_tags
Link table between events and tags

Field Name        Type           Description
-----------       ------         ----------------
event_id          integer        The event ID
tag_id            integer        The tag ID

### events_urls
Link table between events and urls

Field Name        Type           Description
-----------       ------         ----------------
event_id          integer        The event ID
url_id            integer        The URL ID

### images
Details of each image in the data store

Field Name               Type           Description
-----------              ------         ----------------
camera_id                integer        The ID of the camera that took the image
date                     date           The date on which the image was captured
image_present            boolean        Indicates whether the image file exists
image_time               datetime       The exact time at which the image was captured
weather_time             datetime       The timestamp of the weather details recorded alongside the image
temperature              integer        The temperature at the time the image was taken
weather_code             integer        The code for the weather conditions at the time the image was taken
wind_speed               integer        The wind speed at the time the image was taken
wind_bearing             integer        The wind direction at the time the image was taken
rain                     float          The rainfall at the time the image was taken
visibility               float          The visibility at the time the image was taken
pressure                 integer        The atmospheric pressure at the time the image was taken
cloud_cover              integer        The cloud cover at the time the image was taken
air_quality              integer        The air quality at the time the image was taken
humidity                 integer        The humidity at the time the image was taken
image_timezone_id        string         The time zone in effect at the time the image was taken
weather_timezone_id      string         The time zone in effect at the time the weather data was retrieved
image_daylight_saving    boolean        Indicates if daylight savings time was in effect when the image was taken
weather_daylight_saving  boolean        Indicates if daylight savings time was in effect when the weather data was retrieved
image_time_offset        integer        The local time offset from UTC (in seconds) when the image was taken
weather_time_offset      integer        The local time offset from UTC (in seconds) when the weather data was retrieved

### message_types
The templates for different message types

Field Name            Type           Description
-----------           ------         ----------------
code                  string         The code of the message type
subject               string         The subject title of the message
text                  string         The text of the message

Both the subject and the text may contain placeholders to be replaced with specific per-message information.

### messages
Messages generated by the system

Field Name            Type           Description
-----------           ------         ----------------
camera_id             integer        The ID of the camera for which the message was generated
timestamp             datetime       The date and time at which the message was generated
message_type          integer        The ID of the message type
read_by_user          boolean        Indicates whether the message has been read by the camera owner
read_by_admin         boolean        Indicates whether the message has been read by an administrator
resolved              boolean        Indicates whether the problem raised by the message has been resolved
despatched_to_user    boolean        Indicates whether the message has been sent to the camera owner
message               string         The message text
can_despatch          boolean        Indicates whether the message has been flagged for despatch to the camera owner
extra_text            string         Additional text to be attached to the message
extra_data            blob           Additional binary data (usually an image) to be attached to the message

### upload_responses
The set of possible responses to submissions to the image store

Field Name            Type           Description
-----------           ------         ----------------
code                  integer        The HTTP response code
message               string         The message string

### users
User details

Field Name            Type           Description
-----------           ------         ----------------
username              string         The user's username
password_digest       string         Password digest
password_salt         string         Password salt
email                 string         The user's email address
firstname             string         The user's first name
lastname              string         The user's last name
address1              string         The first line of the user's address
address2              string         The second line of the user's address
address3              string         The third line of the user's address
city                  string         The user's city
county                string         The user's county
country               string         The user's country
postcode              string         The user's postal code
privileges            integer        Bit mask of user privileges

### weather codes
Text descriptions of individual weather codes

Field Name            Type           Description
-----------           ------         ----------------
code                  integer        The weather code
condition             string         The description of the weather conditions
