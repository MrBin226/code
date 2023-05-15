function out = colorconv_IPCV(spec,wlength,lsource,system)
% COLORCONV_IPCV calculates color coordinates for input spectra.
%
% colorconv_IPCV(spec,wlength,lsource,system)
% 
% The function calculates and returns color coordinates for input spectra according to given parameters, wavelength and light source.
%
% spec = spectral image / set of spectra - spectral dimension should be the last dimension of matrix
% wlength = wavelength vector, [start resolution stop]
% lsource = light source, available source types are: 'A' 'B' 'C' 'D50' 'D65' 'F2' 'F8' 'F11'
% system = used system, either CIE1931 or CIE1964 - use integer values 1931 or 1964 to select system
% out(:,:,1:3) = sRGB, scaled between 0 and 1
% out(:,:,4:6) = XYZ
% out(:,:,7:9) = L*a*b*
%
% Values of input reflectance spectra must be between 0 and 1. All input parameters are obligatory.
%
% coords = colorconv_IPCV(specimage,[380 5 780],'D65',1931) stores color coordinate values calculated from specimage (using D65 light source and 1931 system) to coords
%
% colorconvRGB
% 
% 2003-06-26, Tuija Kareinen
%
% lsources.dat
% xyz1931.dat
% xyz1964.dat
%
% 2003-07-04, added possibility to use user defined spectrum instead of light source, Tuija Kareinen
% 2003-07-23, replaced for-loops for RGB value calculation with more efficient operations, Tuija Kareinen
% 2003-08-06, added light source column number to output parameters, Tuija Kareinen
% 2003-11-20, moved static calculations (lightxyz) outside for-loop, Tuija Kareinen
% 2004-04-26, updated all RGB calculations to sRGB, Tuija Kareinen
% 2005-01-05, modified xyz-calculations (avoiding division by zero), Tuija Jetsu
% 2005-02-28, compatibility for 2-D matrices added, Tuija Jetsu
% 2007-03-01, update for special size matrices (1x1xn), Tuija Jetsu
% 2008-08-17, cleanup and combatibility checks for IPCV08, Tuija Jetsu

% Selecting light source lsource.
% If given parameter isn't found from list, using D65

lsource = upper(lsource);

if(strcmp(lsource, 'A')) lcol = 2;
elseif (strcmp(lsource, 'B')) lcol = 3;
elseif (strcmp(lsource, 'C')) lcol = 4; 
elseif (strcmp(lsource, 'D65')) lcol = 5;
elseif (strcmp(lsource, 'D50')) lcol = 6;
elseif (strcmp(lsource, 'F2')) lcol = 7;
elseif (strcmp(lsource, 'F8')) lcol = 8;
elseif (strcmp(lsource, 'F11')) lcol = 9;
else lcol = 5;
end;

load lsources.dat;


% Selecting color-matching functions from 1931 or 1964
if (system == 1964)
    load xyz1964.dat; st = xyz1964;
else
    load xyz1931.dat; st = xyz1931;
end;

wave = (wlength(1):wlength(2):wlength(3))';
if sum(abs(wave-round(wave))) > 0 
    % wavelength resolution not integer, interpolation needed
    ciex = interp1(st(:,1), st(:,2), wave);
    ciey = interp1(st(:,1), st(:,3), wave);
    ciez = interp1(st(:,1), st(:,4), wave);
    light = interp1(lsources(:,1), lsources(:,lcol), wave);
else
    % no interpolation needed
    lsources = lsources((wlength(1) - lsources(1,1) + 1):wlength(2):(wlength(3)-lsources(1,1)+1),:);
    light = lsources(:,lcol);
    st = st((wlength(1) - st(1,1) + 1):wlength(2):(wlength(3)-st(1,1)+1),:);
    ciex = st(:,2);
    ciey = st(:,3);
    ciez = st(:,4);
end;

[a b c] = size(spec);
k = 100/(ciey' * light);
lightxyz = zeros(3, size(light,1));
lightxyz(1,:) = (ciex .* light)';
lightxyz(2,:) = (ciey .* light)';
lightxyz(3,:) = (ciez .* light)';

% Constants for XYZ, CIELAB:
% Calculate exact values for reference white
if min(wave) < 420 & max(wave) > 680
    X0 = k * (ciex' * light);
    Y0 = 100; % Y0 = k * (ciey' * light);
    Z0 = k * (ciez' * light);
else % Use precalculated values, if spectra too narrow
    if system == 1931 % (calc. from 380:10:780)
        if lcol == 2 X0 = 109.83; Y0 = 100; Z0 = 35.55;
        elseif lcol == 3 X0 = 99.07; Y0 = 100; Z0 = 85.22;
        elseif lcol == 4 X0 = 98.04; Y0 = 100; Z0 = 118.10;
        elseif lcol == 5 X0 = 95.02; Y0 = 100; Z0 = 108.81;
        else X0 = 95.02; Y0 = 100; Z0 = 108.81;
        end;
    else % (calc. from 380:5:780)
        if lcol == 2 X0 = 111.15; Y0 = 100; Z0 = 35.20;
        elseif lcol == 3 X0 = 99.19; Y0 = 100; Z0 = 84.36;
        elseif lcol == 4 X0 = 97.28; Y0 = 100; Z0 = 116.14;
        elseif lcol == 5 X0 = 94.81; Y0 = 100; Z0 = 107.33;
        else X0 = 94.81; Y0 = 100; Z0 = 107.33;
        end;
    end;
end;

if ndims(spec) > 2
    out = zeros(a, b, 12);
else
    % 2-D spectra, can be processed at once
    out = zeros(a, 12);
    a = 1;
end;

for i=1:a

% processing image: removing singleton dimensions, if needed
if (ndims(spec) > 2) && (size(spec,1) > 1)
    % 3-D spectra, processing row by row
    image = squeeze(spec(i,:,:))';
elseif (ndims(spec) > 2) && (size(spec,1) == 1) && (size(spec,2) > 1)
    % 3-D spectra, processing row by row
    image = squeeze(spec)';
elseif (ndims(spec) > 2) && (size(spec,1) == 1) && (size(spec,2) == 1)
    image = squeeze(spec);
else
    % 2-D spectra, processing all at once
    image = spec';
end;

%% CIE XYZ coordinates, out(:,:,4:6) 
X = k * (lightxyz(1,:) * image);
Y = k * (lightxyz(2,:) * image);
Z = k * (lightxyz(3,:) * image);

if ndims(spec) > 2
    out(i,1:b,4)=X;
    out(i,1:b,5)=Y;
    out(i,1:b,6)=Z;
else
    out(:,4)=X;
    out(:,5)=Y;
    out(:,6)=Z;
end;

%% RGB coordinates: if sRGB is selected, multiplication with a different matrix
% note that conversions hold on only for CIE standard observers!!
RGBs=([3.2410,-1.5374,-0.4986;-0.9692,1.8760,0.0416;0.0556,-0.2040,1.0570]*[X;Y;Z])';

% The range for valid RGB values in Matlab / RGB image is [0,1], dividing calculated values by 100. 
% Replacing negative RGB values with zero and values bigger than 1 with one
RGBs = RGBs/100;
RGBs = min(1, RGBs);
RGBs = max(0, RGBs);

% applying gamma correction
tmp = find(RGBs <= 0.00304);
tmp2 = find(RGBs > 0.00304);
RGBs(tmp) = 12.92*RGBs(tmp);
RGBs(tmp2) = 1.055*(RGBs(tmp2).^(1/2.4))-0.055;
if ndims(spec) > 2
    out(i,1:b,1:3)=RGBs;
else
    out(:,1:3)=RGBs;
end;

%% CIELAB coordinates, out(:,:,7:9)
FX = X/X0;
FY = Y/Y0;
FZ = Z/Z0;

I = find(FY > 0.008856);
if ~isempty(I)
    Lt(I) = 116 * FY(I).^(1/3) - 16;
    YY(I) = FY(I).^(1/3);
end
I = find(FY <= 0.008856);
if ~isempty(I)
    Lt(I) = 903.292 * FY(I);
    YY(I) = 7.787 * FY(I) + 16/116;
end

I = find(FX > 0.008856);
if ~isempty(I)
    XX(I) = FX(I).^(1/3);
end
I = find(FX <= 0.008856);
if ~isempty(I)
    XX(I) = 7.787 * FX(I) + 16/116; 
end

I = find(FZ > 0.008856);
if ~isempty(I)
    ZZ(I) = FZ(I).^(1/3);
end
I = find(FZ <= 0.008856);
if ~isempty(I)
    ZZ(I) = 7.787 * FZ(I) + 16/116;
end

at = 500 * (XX - YY);
bt = 200 * (YY - ZZ);
if ndims(spec) > 2
    out(i,1:b,10)=Lt;
    out(i,1:b,11)=at;
    out(i,1:b,12)=bt;
else
    out(:,10)=Lt;
    out(:,11)=at;
    out(:,12)=bt; 
end;

end; % for i=1:a
