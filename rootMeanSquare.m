function [RMS] = rootMeanSquare(data)
%���������
%   �˴���ʾ��ϸ˵��
a=sum(data.^2);
RMS=sqrt(a/length(data));
end

