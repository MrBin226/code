function Lab = XYZ_2_Lab(XYZ,wlength,lsource,system,lsources,st)
% 建立一个XYZ 到Lab的转换

%
% lsources.dat
% xyz1931.dat
% xyz1964.dat
%%% 建立 不同 光源的 映射。

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




% Selecting color-matching functions from 1931 or 1964


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

% [a b c] = size(spec);
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


X=XYZ(:,1);
Y=XYZ(:,2);
Z=XYZ(:,3);
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

    Lab(:,1)=Lt;
    Lab(:,2)=at;
    Lab(:,3)=bt; 


