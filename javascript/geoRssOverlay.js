// GeoRssOverlay: GMaps API extension to display a group of markers from
// a RSS feed
//
// Copyright 2006 Mikel Maron (email: mikel_maron yahoo com)
//
// The original version of this code is called MGeoRSS and can be found
// at the following adress:
// http://brainoff.com/gmaps/mgeorss.html
//
// Modified and bundled with YM4R in accordance with the following
// license:
//
// This work is public domain

function GeoRssOverlay(rssurl,icon,proxyurl){
    this.rssurl = rssurl;
    this.icon = icon;
    this.proxyurl = proxyurl;
    this.request = false;
    this.markers = [];
}

GeoRssOverlay.prototype = new GOverlay();

GeoRssOverlay.prototype.initialize=function(map) {
    this.map = map;
    this.load();
}

GeoRssOverlay.prototype.redraw = function(force){
    //nothing to do : the markers are already taken care of
}

GeoRssOverlay.prototype.remove = function(){
    for(var i= 0, len = this.markers.length ; i< len; i++){
	this.map.removeOverlay(this.markers[i]);
    }
}

GeoRssOverlay.prototype.copy = function(){
    var oCopy = new GeoRssOVerlay(this.rssurl,this.icon,this.proxyurl);
    oCopy.markers = [];
    for(var i = 0 , len = this.markers.length ;i < len ; i++){
	oCopy.markers.push(this.markers[i].copy());
    }
    return oCopy;
}

GeoRssOverlay.prototype.load=function() {
    if (this.request != false) { 
	return; 
    }
    this.request = GXmlHttp.create();
    if (this.proxyurl != undefined) {
	this.request.open("GET",this.proxyurl + '?q=' + encodeURIComponent(this.rssurl),true);
    } else {
	this.request.open("GET",this.rssurl, true);
    }
    var m = this;
    this.request.onreadystatechange = function() {
	m.callback();
    }
    this.request.send(null);
}

GeoRssOverlay.prototype.callback = function() {
    if (this.request.readyState == 4) {
	if (this.request.status == "200") {
	    var xmlDoc = this.request.responseXML;
	    var items = xmlDoc.documentElement.getElementsByTagName("item");
	    for (var i = 0; i < items.length; i++) {
		try {
		    var marker = this.createMarker(items[i]);
		    this.markers.push(marker);
		    this.map.addOverlay(marker);
		} catch (e) {
		}
	    }
	}
	this.request = false;
    }
}

GeoRssOverlay.prototype.createMarker = function(item) {
    var title = item.getElementsByTagName("title")[0].childNodes[0].nodeValue;
    var description = item.getElementsByTagName("description")[0].childNodes[0].nodeValue;
    var link = item.getElementsByTagName("link")[0].childNodes[0].nodeValue;
    
    /* namespaces are handled by spec in moz, not in ie */
    if (navigator.userAgent.toLowerCase().indexOf("msie") < 0) {
	var lat = item.getElementsByTagNameNS("http://www.w3.org/2003/01/geo/wgs84_pos#","lat")[0].childNodes[0].nodeValue;
	var lng = item.getElementsByTagNameNS("http://www.w3.org/2003/01/geo/wgs84_pos#","long")[0].childNodes[0].nodeValue;
    } else {
	var lat = item.getElementsByTagName("geo:lat")[0].childNodes[0].nodeValue;
	var lng = item.getElementsByTagName("geo:long")[0].childNodes[0].nodeValue;
    }
    
    var point = new GLatLng(parseFloat(lat), parseFloat(lng));
    var marker = new GMarker(point,{'title': title});
    var html = "<a href=\"" + link + "\">" + title + "</a><p/>" + description;
    
    GEvent.addListener(marker, "click", function() {
	marker.openInfoWindowHtml(html);
    });
    
    return marker;
}
