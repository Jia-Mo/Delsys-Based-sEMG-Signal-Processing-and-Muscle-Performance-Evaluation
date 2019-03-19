function [filter_signal]=notchfilter(data,f0)
Fs=2000;
M=2;
lamda=0.90;
L=length(data);
I=eye(M);
c=0.01;
y_out=zeros(L,1);
filter_signal=zeros(L,1);
w_out=zeros(L,M);
% n=(f0/50)*2;
for i=1:L
    if i==1
        P_last=I/c;
        w_last=zeros(M,1);
    end
    d=data(i);
    x=[sin(2*pi*f0*(i-1)/Fs)
        cos(2*pi*f0*(i-1)/Fs)];
    K=(P_last * x)/(lamda + x'* P_last * x);   %��������ʸ��
    y = x'* w_last;                          %����FIR�˲������
    Eta = d - y;                             %������Ƶ����
    w = w_last + K * Eta;                    %�����˲���ϵ��ʸ��
    P = (I - K * x')* P_last/lamda;          %���������ؾ���
    %��������
    P_last = P;
    w_last = w;
    y_out(i) = y;
    filter_signal(i) = Eta;
    w_out(i,:) = w';
end
end

