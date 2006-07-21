// JS helper functions for YM4R

function addInfoWindowToMarker(marker,info){
	GEvent.addListener(marker, "click", function() {marker.openInfoWindowHtml(info);});
	return marker;
}

function addInfoWindowTabsToMarker(marker,info){
     GEvent.addListener(marker, "click", function() {marker.openInfoWindowTabsHtml(info);});
     return marker;
}

function addPropertiesToLayer(layer,getTile,copyright,opacity,isPng){
    layer.getTileUrl = getTile;
    layer.getCopyright = copyright;
    layer.getOpacity = opacity;
    layer.isPng = isPng;
    return layer;
}

function addOptionsToIcon(icon,options){
    for(var k in options){
	icon[k] = options[k];
    }
    return icon;
}

function addCodeToFunction(func,code){
    if(func == undefined)
	return code;
    else{
	return function(){
	    func();
	    code();
	}
    }
}

function addGeocodingToMarker(marker,address){
    marker.orig_initialize = marker.initialize;
    orig_redraw = marker.redraw;
    marker.redraw = function(force){}; //empty the redraw method so no error when called by addOverlay.
    marker.initialize = function(map){
	new GClientGeocoder().getLatLng(address,
					function(latlng){
	    if(latlng){
		marker.redraw = orig_redraw;
		marker.orig_initialize(map); //init before setting point
		marker.setPoint(latlng);
	    }//do nothing
	});
    };
    return marker;
}



var INVISIBLE = new GLatLng(0,0); //This point doesn't matter
window.onunload = GUnload;
