%matlab��ʼ��
function A()
% clc;             %�������ڵ�����
% clear all;       %��������ռ�����б�������������MEX�ļ�
% close all;       %�ر����е�figure����

%���������ϰ���������趨
n = 20;   % ����һ��n x n�ķ����޸Ĵ�ֵ�����޸�����ͼƬ�ķ�����
% �ϰ�������
wall = [11:20,33:42,69:22:69+2*22,71:22:71+2*22,74:22:74+2*22,76:22:76+2*22,79:22:79+2*22,81:22:81+2*22,84:22:84+2*22,86:22:86+2*22,...
    157:22:157+2*22,159:22:159+2*22,162:22:162+2*22,164:22:164+2*22,167:22:167+2*22,169:22:169+2*22,172:22:172+2*22,174:22:174+2*22,...
    245:22:245+2*22,247:22:247+2*22,250:22:250+2*22,252:22:252+2*22,255:22:255+2*22,257:22:257+2*22,260:22:260+2*22,262:22:262+2*22,...
    333:22:333+2*22,335:22:335+2*22,338:22:338+2*22,340:22:340+2*22,343:22:343+2*22,345:22:345+2*22,348:22:348+2*22,350:22:350+2*22];
startposind = 65;  %��ʼ�������ֵ
goalposind = 177;  %Ŀ��������ֵ

%�����Լ��ϰ���Ĵ���
[field, startposind, goalposind, costchart, fieldpointers] =initializeField(n,wall,startposind,goalposind); %������ɰ����ϰ����ʼ�㣬��ֹ�����Ϣ�ľ���

% ·���滮���õ���һЩ����ĳ�ʼ��
setOpen = [startposind]; setOpenCosts = [0]; setOpenHeuristics = [Inf];
setClosed = []; setClosedCosts = [];
movementdirections = {'R','L','D','U'};  %�ƶ�����


% �����������������ɻ������ϰ����㣬�յ�
axishandle = createFigure(field,costchart,startposind,goalposind);    %��������ɵķ����ϰ������������ͼ��

%%

% ���whileѭ���Ǳ�����ĺ��ģ�����ѭ�����е�����Ѱ����ֹ��
while ~max(ismember(setOpen,goalposind)) && ~isempty(setOpen)
    [temp, ii] = min(setOpenCosts + setOpenHeuristics);     %Ѱ����չ��������Сֵ 
    
    %������������þ��ǰ�����ĵ���Ϊ���ڵ㣬Ȼ�������չ�ҵ��ӽڵ㣬�����ҵ��ӽڵ�Ĵ��ۣ����Ұ��ӽڵ�����յ�Ĵ����ҵ�
    [costs,heuristics,posinds] = findFValue(setOpen(ii),setOpenCosts(ii), field,goalposind,'euclidean');
 
  setClosed = [setClosed; setOpen(ii)];     % ���ҳ�������չ�����ĵ��д�����С���Ǹ��㴮������setClosed �� 
  setClosedCosts = [setClosedCosts; setOpenCosts(ii)];    % ����չ�����ĵ��д�����С���Ǹ���Ĵ��۴�������setClosedCosts ��
  
  % ��setOpen��ɾ���ղŷŵ�����setClosed�е��Ǹ���
  %��������λ�ھ�����ڲ�
  if (ii > 1 && ii < length(setOpen))
    setOpen = [setOpen(1:ii-1); setOpen(ii+1:end)];
    setOpenCosts = [setOpenCosts(1:ii-1); setOpenCosts(ii+1:end)];
    setOpenHeuristics = [setOpenHeuristics(1:ii-1); setOpenHeuristics(ii+1:end)];
    
  %��������λ�ھ����һ��
  elseif (ii == 1)
    setOpen = setOpen(2:end);
    setOpenCosts = setOpenCosts(2:end);
    setOpenHeuristics = setOpenHeuristics(2:end);
    
  %��������λ�ھ�������һ��
  else
    setOpen = setOpen(1:end-1);
    setOpenCosts = setOpenCosts(1:end-1);
    setOpenHeuristics = setOpenHeuristics(1:end-1);
  end
  
 %%  
  % ����չ�����ĵ��з���Ҫ��ĵ�ŵ�setOpen �����У���Ϊ��ѡ��
  for jj=1:length(posinds)
  
    if ~isinf(costs(jj))   % �жϸõ㣨���񣩴�û���ϰ���
        
      % �ж�һ�¸õ��Ƿ� �Ѿ�������setOpen �������setClosed ������
      % �������Ҫ�������չ��Ȳ���setOpen ����Ҳ����setClosed ������
      if ~max([setClosed; setOpen] == posinds(jj))
        fieldpointers(posinds(jj)) = movementdirections(jj);
        costchart(posinds(jj)) = costs(jj);
        setOpen = [setOpen; posinds(jj)];
        setOpenCosts = [setOpenCosts; costs(jj)];
        setOpenHeuristics = [setOpenHeuristics; heuristics(jj)];
        
      % �������Ҫ�������չ���Ѿ���setOpen ������
      elseif max(setOpen == posinds(jj))
        I = find(setOpen == posinds(jj));
        % ���ͨ��Ŀǰ�ķ����ҵ�������㣬��֮ǰ�ķ����ã�����С���͸��������
        if setOpenCosts(I) > costs(jj)
          costchart(setOpen(I)) = costs(jj);
          setOpenCosts(I) = costs(jj);
          setOpenHeuristics(I) = heuristics(jj);
          fieldpointers(setOpen(I)) = movementdirections(jj);
        end
        
        % �������Ҫ�������չ���Ѿ���setClosed ������
      else
        I = find(setClosed == posinds(jj));
        % ���ͨ��Ŀǰ�ķ����ҵ�������㣬��֮ǰ�ķ����ã�����С���͸��������
        if setClosedCosts(I) > costs(jj)
          costchart(setClosed(I)) = costs(jj);
          setClosedCosts(I) = costs(jj);
          fieldpointers(setClosed(I)) = movementdirections(jj);
        end
      end
    end
  end
  
 %% 
  if isempty(setOpen) break; end
  set(axishandle,'CData',[costchart costchart(:,end); costchart(end,:) costchart(end,end)]);
  set(gca,'CLim',[0 1.1*max(costchart(find(costchart < Inf)))]);
  drawnow;
  
end

%%

%����findWayBack��������·�����ݣ������Ƴ�·������
if max(ismember(setOpen,goalposind))
  disp('·�����ҵ�!');
  p = findWayBack(goalposind,fieldpointers); % ����findWayBack��������·�����ݣ������ݽ�����ھ���P��
  plot(p(:,2)+0.5,p(:,1)+0.5,'Color',0.1*ones(3,1),'LineWidth',4);  %�� plot��������·������
  title(['·������Ϊ��',num2str(size(p,1)-1)])
  drawnow;
  drawnow;

elseif isempty(setOpen)
  disp('·��δ�ҵ�!'); 
end


