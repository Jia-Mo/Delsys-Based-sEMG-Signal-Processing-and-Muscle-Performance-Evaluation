function [n] = trend(data)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   n=1�������ƣ�n=0�Ȳ�����Ҳ���½���n=-1�½�����
L=length(data);
S=0;
%��֤����������
if L<=3
    n=0;
    return;
end

%�ж��Ƿ񵥵�
for i=1:(L-1)
    S=S+abs(data(i+1)-data(i));
end
m=abs(data(end)-data(1));
z=m/S;%�𵴳̶ȣ�z=1������
if z<0.2%����
    n=0;
    return;
end

%�ж�����
x=1:L;
p=polyfit(x,data,1);
if p(1)>0.2
    n=1;
else
    if p(1)<-0.2
        n=-1;
    else
        n=0;
    end
end

end

