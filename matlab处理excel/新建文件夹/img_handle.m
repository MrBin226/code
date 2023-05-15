
%%依次读取每一张图片，再储存处理结果
% 图片读取过程需要能够实现连续读取和间隔读取图片，图片最大编号能到1000；
% 数据储存第一列需要设置有编号，依次储存最后一行R所列出的数据，每个工作表储存数据后的名称按照数据对应图片名称命名。

function [R] = img_handle(img_path, tophat_r, op_clo_r)
%%  图片处理程序
    gray= imread(img_path);
   if size(size(gray,3),2)>2
        gray(:,:,2:3)=[];
    end
    gray_db=double(gray);
    blocks=blkproc(gray_db,[256 256],@estibackground);
    background=imresize(blocks,[size(gray,1) size(gray,2)],'bilinear'); 
    gray2=imsubtract(gray_db,background);
    gray_out=medfilt2(gray2,[5 5]);
    aa=min(min(gray_out));bb=max(max(gray_out));
    gray_out=(gray_out-aa)./(bb-aa)*255; 
    clear aa bb
    gray_out=uint8(gray_out);
    image_recon=255-gray_out; 
    se = strel('disk',tophat_r);
    image_recon=imtophat(image_recon,se);
    level = graythresh(image_recon);
     image_bw= im2bw(image_recon,level);
    se = strel('disk',op_clo_r);
    image_erode=imerode(image_bw,se);
    image_recon=imreconstruct(image_erode,image_bw);
    I_opened = imopen(image_recon,se);
    I_close=I_opened;
    s= regionprops(I_close,'Area', 'centroid','Perimeter','MajorAxisLength','MinorAxisLength','Orientation','Circularity','Solidity','EquivDiameter');
    centroids= cat(1, s.Centroid);
    d0=cat(1, s.EquivDiameter);
    major_r=cat(1, s.MajorAxisLength);
    minor_r=cat(1, s.MinorAxisLength);
    Soliditys=cat(1, s.Solidity);
    Areas=cat(1, s.Area);
    Perim=cat(1, s.Perimeter);
    Circ=cat(1, s.Circularity);
    angle=cat(1, s.Orientation);
    
    for i=1:size(centroids,1)
        if centroids(i,1)-10>=1 && centroids(i,1)+10<=size(gray,2) && centroids(i,2)-10>=1 && centroids(i,2)+10<=size(gray,1) 
            FM(i)= fmeasure(gray,'GDER',[centroids(i,1)-10 centroids(i,2)-10 30 30]); 
        end
    end
    
    C=find(FM(:)>10);
    Answer(:,1)=Areas(C);
    Answer(:,2)=centroids(C,1);
    Answer(:,3)=centroids(C,2);
    Answer(:,4)=Perim(C);
    Answer(:,5)=major_r(C);
    Answer(:,6)=minor_r(C);
    Answer(:,7)=angle(C);
    Answer(:,8)=Circ(C);
    Answer(:,9)=Soliditys(C);
    Answer(:,10)=d0(C);

    if size(Answer,1)>0     
        N=size(Answer,1);
        % 存储初步计算结果
        FieldVortexNum(nFile-StartFile+1,1)=N;
        Nt=sum(FieldVortexNum)-N;
        areas(Nt+1:Nt+N,1)=Answer(:,1);
        Position_X(Nt+1:Nt+N,1)=Answer(:,2);
        Position_Y(Nt+1:Nt+N,1)=Answer(:,3);
        perim(Nt+1:Nt+N,1)=Answer(:,4);
        Lmax(Nt+1:Nt+N,1)=Answer(:,5);
        Lmin(Nt+1:Nt+N,1)=Answer(:,6);
        Angle(Nt+1:Nt+N,1)=Answer(:,7);
        circ(Nt+1:Nt+N,1)=Answer(:,8);
        soliditys(Nt+1:Nt+N,1)=Answer(:,9);
        Diam(Nt+1:Nt+N,1)=Answer(:,10);
    end
    Nt=sum(FieldVortexNum);
    clear C FM Answer
   

%%记录数据

        areas(Nt+1:end)=[];
        Position_X(Nt+1:end)=[];
        Position_Y(Nt+1:end)=[];
        perim(Nt+1:end)=[];
        Lmax(Nt+1:end)=[];
        Lmin(Nt+1:end)=[];
        Angle(Nt+1:end)=[];
        circ(Nt+1:end)=[];
        soliditys(Nt+1:end)=[];
        Diam(Nt+1:end)=[];
R=[areas Position_X Position_Y  perim Lmax Lmin Angle circ soliditys Diam];
end

