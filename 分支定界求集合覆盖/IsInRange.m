% IsInRange.m
% �жϷ�֧����Ľ��Ƿ������½�ķ�Χ�У������ڣ���ȥ
function y = IsInRange(fval)
    global lowerBound;
    global upperBound;

    if isempty(upperBound) & fval >= lowerBound
        y = 1;
    else if  (fval >= lowerBound & fval <= upperBound)
        y = 1;
    else
        y = 0;
    end
end
