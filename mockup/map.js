// Map stuff
var mapSource = null;
var map = null;
var mapDiv = null;
var infoPopup = null;
var infoTitle = null;
var infoImage = null;
var currentPopupCamera = null;

function getCameraLayer(projection) {

	var cameras = [

		[1, 1.31618, 52.6327, 284, 'Square Goldfish', 'images/bird.jpg'],
		[2, -4.08443, 52.4206, 267, 'AberCam', 'images/fireworks.jpg'],
		[3, 23.0307, 62.961, 75, 'Lapua City', 'images/hotairballoon.jpg'],
		[4, 39.2641, -6.77709, 200, 'Dar Es Salaam', 'images/pigeon.jpg'],
		[5, 57.727, -20.4294, 0, 'Paradise Beach', 'images/rainbow.jpg'],
		[6, 79.043, 12.235, 90, 'Arunachala Live', 'images/streetlightfix.jpg'],
		[7, 98.2957, 7.89159, 285, 'Patong Tower', 'images/bird.jpg'],
		[8, 114.174, 22.3022, 90, 'Hong Kong Observatory Headquarters', 'images/fireworks.jpg'],
		[9, 147.358, -42.8619, 242, 'Rose Bay High School', 'images/hotairballoon.jpg'],
		[10, 151.28, -33.8896, 222, 'Bondi Beach', 'images/pigeon.jpg'],
		[12, 168.656, -45.0289, 77, 'Deer Park Heights', 'images/rainbow.jpg'],
		[13, -147.719, 64.844, 318, 'Golden Heart Plaza', 'images/streetlightfix.jpg'],
		[14, -123.472, 48.8083, 36, 'Salt Spring Island', 'images/bird.jpg'],
		[15, -105.872, 39.6415, 175, 'Arapahoe Basin', 'images/fireworks.jpg'],
		[16, -63.8097, 10.9924, 26, 'Pampatar', 'Vimages/hotairballoon.jpg'],
		[17, -57.5377, -38.0087, 76, 'Mar del Plata WebCam', 'images/pigeon.jpg'],
		[18, -36.4945, -54.2835, 139, 'South Georgia', 'images/rainbow.jpg'],
		[19, -16.1794, 64.0457, 343, 'Jokulsarlon Kalfafellsstadur', 'images/streetlightfix.jpg'],
		[20, 5.32597, 60.3909, 95, 'Festplassen', 'images/streetlightfix.jpg']
	];

	var cameraFeatures = new Array(cameras.length);


	for (var i = 0; i < cameras.length; i++) {
		cameraFeatures[i] = new ol.Feature({
			geometry: new ol.geom.Point([cameras[i][1], cameras[i][2]]).transform(ol.proj.get("EPSG:4326"), projection),
			name: cameras[i][4],
			imageUrl: cameras[i][5]
		});	
	}

	cameraSource = new ol.source.Vector({
		features: cameraFeatures
	});

	return cameraSource;
}


function displayFeatureInfo(pixel) {
    var feature = map.forEachFeatureAtPixel(pixel, function(feature) {
		return feature;
    });

    if (feature) {

		var featureCoord = ol.proj.toLonLat(feature.getGeometry().getFirstCoordinate());

		var featureCoordOK = false;
		var featurePixel = map.getPixelFromCoordinate(ol.proj.fromLonLat(featureCoord));
		var mapMin = mapDiv.offset().left;
		var mapMax = mapMin + mapDiv.width();


		while (!featureCoordOK) {
			if (featurePixel[0] < mapMin) {
				featureCoord[0] = featureCoord[0] + 360
			} else if (featurePixel[0] > mapMax) {
				featureCoord[0] = featureCoord[0] - 360
			} else {
				featureCoordOK = true;
			}

			featurePixel = map.getPixelFromCoordinate(ol.proj.fromLonLat(featureCoord));
		}

		var camName = feature.get('name');
		if (camName != currentPopupCamera) {
			var horizontal_shift = 25;
			var vertical_shift = 0;

			var topLimit = (infoPopup.height()) + 25;
			var bottomLimit = mapDiv.height() - topLimit - 25;
			var leftLimit = (infoPopup.height()) + 25;
			var rightLimit = mapDiv.width() - leftLimit - 110;

			if (featurePixel[1] <= topLimit) {
				vertical_shift = (infoPopup.height() / 2) + 25;

				if (featurePixel[0] >= rightLimit) {
					horizontal_shift = (infoPopup.width() + 35) * -1;
				} else if (featurePixel[0] > leftLimit) {
					horizontal_shift = (infoPopup.width() / 2) * -1;
				}
			} else if (featurePixel[1] >= bottomLimit) {
				vertical_shift = ((infoPopup.height() / 2) + 50) * -1;

				if (featurePixel[0] >= rightLimit) {
					horizontal_shift = (infoPopup.width() + 35) * -1;
				} else if (featurePixel[0] > leftLimit) {
					horizontal_shift = (infoPopup.width() / 2) * -1;
				}
			} else if (featurePixel[0] >= rightLimit) {
				horizontal_shift = (infoPopup.width() + 35) * -1;
			}

			infoPopup.css({
	  			left: (featurePixel[0] + horizontal_shift) + 'px',
				top: (featurePixel[1] + vertical_shift) + 'px'
			});

			infoTitle.html(feature.get('name'));
			infoImage.attr('src', feature.get('imageUrl'));
			currentPopupCamera = camName;
		}
		infoPopup.fadeIn(100);
		$('#map').css({
			cursor: 'pointer'
		});
	} else {
		infoPopup.fadeOut(100);
		$('#map').css({
			cursor: 'default'
		});
		currentPopupCamera = null;
	}
}

$(document).ready(function() {

	mapSource = new ol.source.Stamen({
  		layer: "terrain",
  		url: "https://stamen-tiles-{a-d}.a.ssl.fastly.net/terrain/{z}/{x}/{y}.png"
	});

	map = new ol.Map({
 		target: 'map',
 		layers: [
    		new ol.layer.Tile({
        		source: mapSource
    		}),
    		new ol.layer.Vector({
      			source: getCameraLayer(mapSource.getProjection()),
      			style: new ol.style.Style({
        			image: new ol.style.Icon({
          				src: 'camera_icon.png'
        			})
      			})
    		})
  		],
  		view: new ol.View({
    		center: ol.proj.fromLonLat([10, 45]),
    		zoom: 4,
    		minZoom: 2
  		}),
	});

	map.on('pointermove', function(evt) {
  		if (evt.dragging) {
    		infoPopup.hide();
    		return;
  		}
 
  		displayFeatureInfo(map.getEventPixel(evt.originalEvent));
	});

	mapDiv = $('#map');
	infoPopup = $('#infoPopup');
	infoTitle = $('#infoTitle');
	infoImage = $('#infoImage');
});
