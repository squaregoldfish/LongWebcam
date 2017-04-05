// Map stuff


function getCameraLayer(projection) {

	var cameras = [

		[1.31618, 52.6327, 284, 'Square Goldfish', 'My own weathercam'],
		[-4.08443, 52.4206, 267, 'AberCam', 'Overlooking Aberystwyth prom'],
		[23.0307, 62.961, 75, 'Lapua City', 'Webcam located in Lapua City, Finland'],
		[39.2641, -6.77709, 200, 'Dar Es Salaam', 'Bagamoyo Road'],
		[57.727, -20.4294, 0, 'Paradise Beach', 'Pointe d\'Esny, Mauritius'],
		[79.043, 12.235, 90, 'Arunachala Live', 'Live Web Camera on Mount Arunachala Tiruvannamalai, South India'],
		[98.2957, 7.89159, 285, 'Patong Tower', 'In this Patong Tower Condominium for rent, the tallest building in Phuket, we offer rental of this luxury holiday apartment on the 15th floor. It\'s fully furnished with a large bedroom, living room, kitchen, dining-room suite, bathroom, high speed ADSL and all modern conveniences. From the nice balcony you will have a stunning sea view to Patong Beach. Prime location – a few minutes walk to the center of the town and the new shopping center. Perfect for couples and people who enjoy life.'],
		[114.174, 22.3022, 90, 'Hong Kong Observatory Headquarters', 'The landmarks as viewed from the camera at the Hong Kong Observatory Headquarters (looking to the east)'],
		[147.358, -42.8619, 242, 'Rose Bay High School', 'Tasmania'],
		[151.28, -33.8896, 222, 'Bondi Beach', 'Australia'],
		[168.656, -45.0289, 77, 'Deer Park Heights', 'Skyline Queenstown Webcam'],
		[-147.719, 64.844, 318, 'Golden Heart Plaza', 'Fairbanks, Alaska'],
		[-123.472, 48.8083, 36, 'Salt Spring Island', 'British Columbia, Canada'],
		[-105.872, 39.6415, 175, 'Arapahoe Basin', 'Colorado'],
		[-63.8097, 10.9924, 26, 'Pampatar', 'Venezuela. Panoramic view of the west side of Margarita Sambil mall.'],
		[-57.5377, -38.0087, 76, 'Mar del Plata WebCam', 'Torreon del Monje o Playa Bristol Mar del Plata, Argentina'],
		[-36.4945, -54.2835, 139, 'South Georgia', 'This webcam is situated in Larsen House at King Edward Point. The view is south east across Cumberland Bay East to Greene Peninsula and the mountains beyond. Dartmouth Point is in the middle ground and Susa Point in the foreground. The steps on the right lead into Larsen House. Tussac grass is growing immediately in front of the steps. From October to March elephant seals, penguins and fur seals will be on the beach in front of the web cam.'],
		[-16.1794, 64.0457, 343, 'Jokulsarlon Kalfafellsstadur', 'Iceland'],
		[5.32597, 60.3909, 95, 'Festplassen', 'Bergen, Norway']
	];

	var cameraFeatures = new Array(cameras.length);


	for (var i = 0; i < cameras.length; i++) {
		cameraFeatures[i] = new ol.Feature(
			new ol.geom.Point([cameras[i][0], cameras[i][1]]).transform(ol.proj.get("EPSG:4326"), projection)
		);	
	}

	cameraSource = new ol.source.Vector({
		features: cameraFeatures
	});

	return cameraSource;
}