clear all
close all

dx=-0.25;
% xstart=
waittime = 60; %in seconds
traveltime = waittime*0.05;
xfinal = -6;
starttime = 3.9769;


files = dir('h4p0in_dx0p25in.SPEED.MSEBP.txt');
fid = fopen(files.name);
a = textscan(fid,'%f %f %f %f');
fclose(fid);
ms = a{1,1};
us = a{1,2};
speedraw = a{1,3};
snr = a{1,4};
timeraw = 1e-3.*ms(:)+1e-6.*us(:)-starttime;

cutoffspeed = .35;


m = size(speedraw,1); 
j = 0;
for i = 1:m
    % creating a vector for all speed, and the time values 
    % that correlate, that are more than the cutoff speed
    if speedraw(i)>cutoffspeed
        j = j+1;
        speed(j) = speedraw(i);
        time(j) = timeraw(i);
    end
end


l = 0;
for i = 1:j
    % creating a vector for time and correlating 
    % speed that takes into account travel time 
    if mod(time(i),waittime)>traveltime && mod(time(i),waittime)<.95*waittime
        l = l+1;
        nspeed(l) = speed(i);
        ntime(l) = time(i);
    end
end


% Group speed measurements with similar position

for i = 1:(size(ntime,2))
    position = ceil(ntime(i)/waittime);
    b(i,:) = [nspeed(1,i), position];
end

% Average speed at each position

t = 0;

for i = 1:((xfinal/dx)+1)
    k = find(b(:,2) == i);
    
    final(i,1) = (i-1)*dx;
    final(i,2) = mean(b(k,1));
    err(i) = std(b(k,1));
end


errorbar(final(:,1),final(:,2), err(:));



% Final is an array with column 1 containing the 
% average speed at each position (column 2) 