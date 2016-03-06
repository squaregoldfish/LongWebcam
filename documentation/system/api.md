% LongWebcam Public API

# Version History

Version      Date          Description
-------      ------        --------------------------------------------------------
0.1          6 Mar 2016    Image upload API

# Introduction
This document describes the public API for the Long Webcam site. The API provides functionality for uploading images and other functions that do not require the user to be logged in to the main website.

# Uploading Images
All images from cameras are submitted in the form of an XML document, which contains the image file data and all its metadata. This document is uploaded to a specific upload URL on the server as a standard HTTP `POST` request (`GET` requests are not accepted). The server extracts and stores the data, and returns an XML document indicating the success (or reason for failure) of the processing as the response to the request.

## Upload XML
The image upload XML takes the following form:

```{.xml}
<?xml version="1.0" encoding="UTF-8"?>
<image_upload xmlns="http://www.longwebcam.org/xml/upload"  
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://www.longwebcam.org/xml/upload image_upload.xsd">
    <camera>
        <id>1</id>
        <code>6067</code>
    </camera>
    <image>
        <date>2013-01-01T01:01:01+00:00</date>
        <file_data>**Base64'd image data**</file_data>
    </image>
    <weather>
        <time>2013-01-01T01:01:01+00:00</time>
        <temperature>29</temperature>
        <weather_code>102</weather_code>
        <wind_speed>5</wind_speed>
        <wind_bearing>231</wind_bearing>
        <rain>0</rain>
        <humidity>45</humidity>
        <visibility>9999</visibility>
        <pressure>1003</pressure>
        <cloud_cover>90</cloud_cover>
        <air_quality>-1</air_quality>
    </weather>
</image_upload>
```

The `camera` tag contains the database ID for the camera to which the image belongs and a security code. The security code will help to prevent images being uploaded for the wrong camera by mistake, or malicious uploading of images for specific cameras.

The `image` tag contains the date and time that the image was taken, and the image data itself. The image must be Base64 encoded, and can be in any format supported by ImageMagick. All images will be converted to PNG format when they are stored.

The `weather` tag is optional, and contains the weather observations taken at the same time as the image. These will be downloaded from [World Weather Online](http://www.worldweatheronline.com).[^1] If the weather information is not supplied, it will be automatically downloaded from World Weather Online at a later time by an automated process.

[^1]: In the future, weather information may be supplied from an alternative source, e.g. a weather station at the same site as the camera.

## Response {#response}
In most cases, the upload XML will be processed and an HTTP `200` response will be returned along with an [XML document](#responseXML). However, there are circumstances when the XML cannot be processed, in which case different HTTP codes will be returned. These are as follows:

HTTP Response Code         Meaning
------------------         -----------------------
`400`                      The `image_details` parameter (which should contain the upload XML) is missing, or the supplied XML does not conform to the Upload XML schema.
`403`                      The request is not an HTTP `POST` request.

If any other response is received, the uploading program should store the data locally, and try to re-send it periodically.

### Response XML {#reponseXML}
The response to the upload request will be an XML document of the form:

```{.xml}
<?xml version="1.0" encoding="UTF-8"?>
<upload_response xmlns="http://www.longwebcam.org/xml/upload_response"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xsi:schemaLocation="http://www.longwebcam.org/xml/upload_response upload_response.xsd">
  <code>200</code>
  <message>OK</message>
</upload_response>
```

The `code` can be used programmatically to react appropriately to the response, while the `message` is a human-readable version of the response. The codes are approximately analagous to standard HTTP response codes, but they should not be confused with the [actual HTTP response codes returned by the request](#response). The possible responses are as follows:

Code         Message
------       ---------------
`200`        Image stored successfully
`400`        Bad image data (ImageMagick could not process the image)
`403`        Forbidden (The security code does not match the camera ID)
`404`        No such camera (The camera ID was not recognised)
`409`        Image already uploaded (There is already an image stored for this day)
`500`        Unknown server error
`507`        Server out of space (no disk space available on server)

If a `500` or `507` code is received, the uploading program should store the image locally, and try to send it again periodically.
