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

window.onunload = GUnload;
