function [RS] = windowRMS(data)
%�󼡵��źŵľ�����ֵ�����ڴ�СΪ50���غ�40
%   �˴���ʾ��ϸ˵��
n=(length(data)-50)/10+1;
n=floor(n);%���ڵ�����
RS=zeros(n,1);
for i=1:n
    data_window=data((10*(i-1)+1):(10*(i-1)+50));
    RS(i)=rootMeanSquare(data_window);
end
end

