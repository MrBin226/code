
%%依次读取每一张图片，提取粒子，然后再用自编粒子匹配程序
clc;
clear all;
close all;
%图片二值化参数-------------------------------------------
tophat_r=130; 
op_clo_r=2;   

pictype='.bmp';
StartFile=001;       
EndFile=368;        
FileStep=100;       
nFile=StartFile:FileStep:EndFile-1;
pt = 'H:\实验\0-200-20\';
ext = '*.BMP';
dis = dir([pt ext]);
nms = {dis.name};

for k = 1:100:length(nms)
    nm = [pt nms{k}];
    gray= imread(nm);

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
     %figure, imshow(gray_out),title('gray_out')
    clear aa bb
    gray_out=uint8(gray_out);
   
    image_recon=255-gray_out; 
  
    se = strel('disk',tophat_r);
    
    image_recon=imtophat(image_recon,se);
   
    level = graythresh(image_recon);
   
     
     image_bw= im2bw(image_recon,level);
    se = strel('disk',op_clo_r);%形态学重构去除噪声粒子
    % figure, imshow( se.Neighborhood ),title('se ')
    image_erode=imerode(image_bw,se);
    image_recon=imreconstruct(image_erode,image_bw);
    % figure, imshow( image_recon ),title('image_recon ')
    %--------形态学开闭运算，修缮图片
    I_opened = imopen(image_recon,se);
    I_close=I_opened;
   %figure, imshow(I_close),title('I_close')
    s= regionprops(I_close,'Area', 'centroid','Perimeter','MajorAxisLength','MinorAxisLength','Orientation','Circularity','Solidity','EquivDiameter');
    centroids= cat(1, s.Centroid);%提取出形心位置
    d0=cat(1, s.EquivDiameter);%相同面积圆的直径
    major_r=cat(1, s.MajorAxisLength);%椭圆长轴长度
    minor_r=cat(1, s.MinorAxisLength);%椭圆短轴长度
    Soliditys=cat(1, s.Solidity);
    Areas=cat(1, s.Area);%粒子面积
    Perim=cat(1, s.Perimeter);%粒子周长
    Circ=cat(1, s.Circularity);%粒子圆度
    angle=cat(1, s.Orientation);%长轴与x轴夹角
    
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
   
end




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

R=[areas Position_X Position_Y  perim Lmax Lmin Angle circ soliditys Diam];%单位为像素


