function track = loadgpx(fileName,varargin)                                
%LOADGPX Loads route points from a GPS interchange file
% ROUTE = LOADGPX(FILENAME) Loads route point information from a .GPX
%   GPS interchange file.  This utility is not a general-purpose
%   implementation of GPX reading and is only used for demonstration.
%
% track is a Nx6 array where each row is a track point
%   Columns 1-3 are the X, Y, and Z coordinates
%   Column  4 is the distance between the track point and its predecessor in km
%   Column  5 is the cumulative track length in km
%   Column  6 is the slope between a track point and its predecessor in percent (%).
%
% See also xmlread

% read the gpx file
d = xmlread(fileName);
if ~strcmp(d.getDocumentElement.getTagName,'gpx')
    warning('loadgpx:formaterror','file is not in GPX format');
end

% get track points from gpx file
pntList = d.getElementsByTagName('trkpt');
% number of track points
pntCt = pntList.getLength;
% empty matrix with route data
trackdata = nan(pntCt,7);
% loop over all track points
for i=1:pntCt
    pt = pntList.item(i-1);
    % read latitude
    try
        trackdata(i,const.COL_LAT) = str2double(pt.getAttribute('lat'));
    catch
        warning('loadgpx:bad_latitude','Malformed latitutude in point %i.  (%s)',i,lasterr);
    end
    
    % read longitude
    try
        trackdata(i,const.COL_LNG) = str2double(pt.getAttribute('lon'));
    catch
        warning('loadgpx:bad_longitude','Malformed longitude in point %i.  (%s)',i,lasterr);
    end
    
    % read elevation
    ele = pt.getElementsByTagName('ele');
    if ele.getLength>0
        try
            trackdata(i,const.COL_Z) = str2double(ele.item(0).getTextContent);
        catch
            warning('loadgpx:bad_elevation','Malformed elevation in point %i.  (%s)',i,lasterr);
        end
    end
end

% compute coordinates as X/Y in kilometers
KM_PER_DEG = 111.3;
trackdata(:,const.COL_X) = 1000 * KM_PER_DEG * cos(trackdata(:,const.COL_LAT)./180.*pi) .* trackdata(:,const.COL_LNG);
trackdata(:,const.COL_Y) = 1000 * KM_PER_DEG * trackdata(:,const.COL_LAT);
trackdata(1,const.COL_SEG_DST) = 0;
trackdata(2:end,const.COL_SEG_DST) = sqrt(sum((trackdata(1:end-1,const.COL_X:const.COL_Y)-trackdata(2:end,const.COL_X:const.COL_Y)).^2,2));
trackdata(:,const.COL_CUM_DST) = cumsum(trackdata(:,const.COL_SEG_DST));


% simple smoothing of height data
temp = zeros(pntCt, 1);
temp(1,1) = trackdata(1,const.COL_Z);
temp(end,1) = trackdata(end,const.COL_Z);
for i = 2:(pntCt-1)
    left_weight = 50 - min(50, trackdata(i,const.COL_SEG_DST));
    center_weight = 50;
    right_weight = 50 - min(50, trackdata(i+1,const.COL_SEG_DST));
    total_weight = left_weight + center_weight + right_weight;
    temp(i,1) = ( left_weight * trackdata(i-1,const.COL_Z) ...
                  + center_weight * trackdata(i,const.COL_Z) ...
                  + right_weight * trackdata(i+1,const.COL_Z) ...
                ) / total_weight;
end
trackdata(:,const.COL_Z) = temp(:,1);      

% resample trackdata for smoother calculations
newSegLen = 50;     % subdivide in 50m intervals
newPntCnt = floor(trackdata(end,const.COL_CUM_DST) / newSegLen);     
track = zeros(newPntCnt,3);

curDist = newSegLen;
curSeg = uint32(2);
track(1,const.COL_X:const.COL_Z) = trackdata(1,const.COL_X:const.COL_Z);
for i = 2:newPntCnt
    a = (curDist-trackdata(curSeg-1,const.COL_CUM_DST)) / trackdata(curSeg,const.COL_SEG_DST);

    if a < 0
        a = 0.0;
    end
    b = max(0.0, 1.0 - a);

    track(i,const.COL_X) = b*trackdata(curSeg-1,const.COL_X) + a*trackdata(curSeg,const.COL_X);
    track(i,const.COL_Y) = b*trackdata(curSeg-1,const.COL_Y) + a*trackdata(curSeg,const.COL_Y);
    track(i,const.COL_Z) = b*trackdata(curSeg-1,const.COL_Z) + a*trackdata(curSeg,const.COL_Z);
    
    curDist = curDist + newSegLen;
    while curDist>trackdata(curSeg,const.COL_CUM_DST)
       curSeg = curSeg + uint32(1);
    end
end

% compute segment and cumulative distance
track(1,const.COL_SEG_DST) = 0;
track(2:end,const.COL_SEG_DST) = sqrt(sum((track(1:end-1,const.COL_X:const.COL_Y)-track(2:end,const.COL_X:const.COL_Y)).^2,2));
track(:,const.COL_CUM_DST) = cumsum(track(:,const.COL_SEG_DST));

% compute segment slope
track(1,const.COL_SLOPE) = 0;
track(2:end,const.COL_SLOPE) = 100 * (track(2:end,const.COL_Z)-track(1:end-1,const.COL_Z)) ./ track(2:end,const.COL_SEG_DST);

% convert distance back to km
track(:,const.COL_X) = track(:,const.COL_X) ./ 1000;
track(:,const.COL_Y) = track(:,const.COL_Y) ./ 1000;
track(:,const.COL_Y) = track(:,const.COL_Y) ./ 1000;
track(:,const.COL_SEG_DST) = track(:,const.COL_SEG_DST) ./ 1000;
track(:,const.COL_CUM_DST) = track(:,const.COL_CUM_DST) ./ 1000;

%disp( track );

end




