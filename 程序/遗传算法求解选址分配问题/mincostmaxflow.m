%��С������������� 

function[flow,val]=mincostmaxflow(rongliang,cost,M,num,flowvalue)

%��һ���������������󣻵ڶ������������þ��� 

%ǰ�������������ڲ�ͨ·������ 

%������������ָ������ֵ�����Բ�д����ʾ����С����������� 

%����ֵ flow Ϊ����������,val Ϊ��С����ֵ 


flow=zeros(size(rongliang));allflow=sum(flow(1,:));

if nargin<5 

   flowvalue=M; 

end 

while allflow<flowvalue 
   w=(flow<rongliang).*cost-((flow>0).*cost)'; 

   path=floydpath(w,M,num);%���� floydpath ����

   if isempty(path) 

       val=sum(sum(flow.*cost)); 

       return; 

   end 

   theta=min(min(path.*(rongliang-flow)+(path.*(rongliang-flow)==0).*M)); 

   theta=min([min(path'.*flow+(path'.*flow==0).*M),theta]); 

   flow=flow+(rongliang>0).*(path-path').*theta; 

   allflow=sum(flow(1,:)); 

end 

val=sum(sum(flow.*cost));
