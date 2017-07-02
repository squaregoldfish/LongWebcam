// Page global variables
var map = null;
var mapSource = null;
var searchResults = null;
var searchResultsMapLayer = null;
var onLoadRun = false;
var currentPopupCamera = null;
var searchTimer = null;

// Page load JS. Decides what to do based on the page contents
$(document).on('turbolinks:load', function () {
  if (!onLoadRun) {
    if ($('#searchMap').length) {
      drawSearchMap();
    }

    if ($('#searchForm').length) {
      $('#searchForm').on('ajax:success', function(e, data, status, xhr) {
        searchResults = JSON.parse(xhr.responseText);
        drawSearchResults();  
      });

      $('#searchForm').on('submit', function() {
        if (null != searchTimer) {
          clearTimeout(searchTimer);
          searchTimer = null;
        }
      });

      $('#freetext').on('keyup', function() {
        freetextSearch();
      });

      $('input[id^=resultsMode').on('change', function() {
        changeResultsMode();
      });

      bindingsAdded = true;
    }

    $('#searchForm').submit();

    onLoadRun = true;
  }
});

function freetextSearch() {
  if (null != searchTimer) {
    clearTimeout(searchTimer);
  }
  searchTimer = setTimeout("$('#searchForm').submit()", 200);
}

function drawSearchMap() {
	if (null == map) {
    mapSource = new ol.source.Stamen({
      layer: "terrain",
      url: "https://stamen-tiles-{a-d}.a.ssl.fastly.net/terrain/{z}/{x}/{y}.png"
    });

    map = new ol.Map({
      target: 'searchMap',
      layers: [
      new ol.layer.Tile({
        source: mapSource
      })
      ],
      view: new ol.View({
        center: ol.proj.fromLonLat([10, 45]),
        zoom: 4,
        minZoom: 2
      })
    });

    map.on('pointermove', function(evt) {
      if (evt.dragging) {
        $('#infoPopup').hide();
        return;
      }

      displayFeatureInfo(map.getEventPixel(evt.originalEvent));
    });

  }
}

function drawSearchResults() {
  var countHtml = searchResults.length + ' camera';
  if (searchResults.length != 1) {
    countHtml += 's';
  }
  $('#resultsCount').html(countHtml);

  switch($('[id^=resultsMode]:checked').val()) {
  case 'map': {
    drawMapSearchResults();
    break;
  }
  case 'list': {
    drawListSearchResults();
    break;
  }
  }
}

function drawMapSearchResults() {
  if (null != searchResultsMapLayer) {
    map.removeLayer(searchResultsMapLayer);
    searchResultsMapLayer = null;
  }

  var cameraFeatures = new Array(searchResults.length);

  for (var i = 0; i < searchResults.length; i++) {
    var camera = searchResults[i];
    cameraFeatures[i] = new ol.Feature({
      geometry: new ol.geom.Point([camera['longitude'], camera['latitude']]).transform(ol.proj.get("EPSG:4326"), mapSource.getProjection()),
      name: camera['title'],
      imageUrl: camera['url']
    }); 
  }

  searchResultsMapLayer = new ol.layer.Vector({
    source: new ol.source.Vector({
      features: cameraFeatures
    }),
    style: new ol.style.Style({
      image: new ol.style.Icon({
        src: '/assets/camera_icon.png'
      })
    })
  });

  map.addLayer(searchResultsMapLayer);
}

function displayFeatureInfo(pixel) {
  var feature = map.forEachFeatureAtPixel(pixel, function(feature) {
    return feature;
  });

  if (feature) {

    var featureCoord = ol.proj.toLonLat(feature.getGeometry().getFirstCoordinate());

    var featureCoordOK = false;
    var featurePixel = map.getPixelFromCoordinate(ol.proj.fromLonLat(featureCoord));
    var mapMin = $('#searchMap').offset().left;
    var mapMax = mapMin + $('#searchMap').width();

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

      var topLimit = ($('#infoPopup').height()) + 25;
      var bottomLimit = $('#searchMap').height() - topLimit - 25;
      var leftLimit = ($('#infoPopup').height()) + 25;
      var rightLimit = $('#searchMap').width() - leftLimit - 110;

      if (featurePixel[1] <= topLimit) {
        vertical_shift = ($('#infoPopup').height() / 2) + 25;

        if (featurePixel[0] >= rightLimit) {
          horizontal_shift = ($('#infoPopup').width() + 35) * -1;
        } else if (featurePixel[0] > leftLimit) {
          horizontal_shift = ($('#infoPopup').width() / 2) * -1;
        }
      } else if (featurePixel[1] >= bottomLimit) {
        vertical_shift = (($('#infoPopup').height() / 2) + 50) * -1;

        if (featurePixel[0] >= rightLimit) {
          horizontal_shift = ($('#infoPopup').width() + 35) * -1;
        } else if (featurePixel[0] > leftLimit) {
          horizontal_shift = ($('#infoPopup').width() / 2) * -1;
        }
      } else if (featurePixel[0] >= rightLimit) {
        horizontal_shift = ($('#infoPopup').width() + 35) * -1;
      }

      $('#infoPopup').css({
        left: (featurePixel[0] + horizontal_shift) + 'px',
        top: (featurePixel[1] + vertical_shift) + 'px'
      });

      $('#infoTitle').html(feature.get('name'));
      $('#infoImage').attr('src', '/assets/camera_icon.png');
      $('#infoImage').attr('src', feature.get('imageUrl'));
      currentPopupCamera = camName;
    }
    $('#infoPopup').fadeIn(100);
    $('#searchMap').css({
      cursor: 'pointer'
    });
  } else {
    $('#infoPopup').fadeOut(100);
    $('#searchMap').css({
      cursor: 'default'
    });
    currentPopupCamera = null;
  }
}

function changeResultsMode() {
  switch($('[id^=resultsMode]:checked').val()) {
  case 'map': {
    $('#searchList').hide();
    $('#searchMap').show();
    drawMapSearchResults();
    break;
  }
  case 'list': {
    $('#searchMap').hide();
    $('#searchList').show();
    drawListSearchResults();
    break;
  }
  }
}

function drawListSearchResults() {

  var html = '';

  if (searchResults.length == 0) {
    html += 'No cameras found';
  } else {
    
    for (var i = 0; i < searchResults.length; i++) {
      var result = searchResults[i];

      html += '<div id="camera-' + result['id'] + '" class="listResult">';
      html += '<div class="listResultLeft">';
      html += '<div class="listImage"><img src="' + result['url'] + '" class="thumbnail"/></div>';
      html += '<div class="listCountry">' + result['country'] + '</div>';
      html += '</div><div class="listResultRight">';
      html += '<div class="listTitle">' + result['title'] + '</div>';
      html += '<div class="listDescription">' + result['description'] + '</div>';
      html += '</div></div>';
    }

  }
  $('#searchList').html(html);
}
