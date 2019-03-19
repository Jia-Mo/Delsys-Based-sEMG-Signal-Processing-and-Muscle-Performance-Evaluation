function [filtered_signal] = process(data,channel)
%1.��ͨ�˲� 2.�ݲ��˲�
%   �˴���ʾ��ϸ˵��
filtered_signal=[];
if ~isempty(data)
    %     data1=bandpass(data,10,500);
%     savepath='data\';
%     dlmwrite([savepath,'rawdata_channel',num2str(channel)], data);
    
    dim=1;
    wl=10;
    wh=500;
    samplingRate=2000;
    data1= ideal_bandpassing(data, dim, wl, wh, samplingRate);
    
%     dlmwrite([savepath,'AFBandPass_channel',num2str(channel)], data1);
    
    Fs=2000;
    
    %     f0=100;
    %     Q=100;%Ʒ������
    %     wo=f0/(Fs/2);
    %     bw=wo/Q;
    %     [b1,a1]=iirnotch(wo,bw);%���100�����ݲ��˲���
    %     data2=filter(b1,a1,data1);%100���ȹ����ź�
    
    data2=notchfilter(data1,50);
    
%     dlmwrite([savepath,'AFBPand50HzNF_channel',num2str(channel)], data2);
    
    %     f01=50;
    %     Q=100;
    %     wo=f01/(Fs/2);
    %     bw=wo/Q;
    %     [b2,a2]=iirnotch(wo,bw);%���50�����ݲ��˲���
    %     filtered_signal=filter(b2,a2,data2);%50���ȹ����ź�
    
    filtered_signal=notchfilter(data2,100);
    
%     dlmwrite([savepath,'filtereddata_channel',num2str(channel)], filtered_signal);
    
    
    
    if  0
        L=length(data);%�źų���
        Fs=1000;%����Ƶ��
        T=1/Fs;%����ʱ��
        t=(0:L-1)*T;%ʱ��
        N=2^nextpow2(L);%��������������Խ���ֵԽ��ȷ
        
        offt=fft(data,N)/N*2;%��ʵ��ֵ
        offt=abs(offt);
        
        yfft=fft(filtered_signal,N)/N*2;%��ʵ��ֵ
        yfft=abs(yfft);
        
        f=Fs/N*(0:N-1);%Ƶ��
        
        figure(2)
        subplot(2,1,1)
        plot(f(1:N/2),offt(1:N/2));%fft���ص����ݽṹ���жԳ������ֻȡһ��
        grid;
        ylim([0 0.00005]);
        xlabel('Frequency(Hz)');
        ylabel('Magnitude(dB)');
        title('Input signal');%ԭʼ�źŸ���Ҷ�任
        
        subplot(2,1,2);
        plot(f(1:N/2),yfft(1:N/2));
        grid;
        ylim([0 0.00005]);
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        title('Filter output');%�˲����źŵĸ���Ҷ�任
        
        
        
        offt=fft(data1,N)/N*2;%��ʵ��ֵ
        offt=abs(offt);
        
        yfft=fft(data2,N)/N*2;%��ʵ��ֵ
        yfft=abs(yfft);
        
        figure(3)
        subplot(2,1,1)
        plot(f(1:N/2),offt(1:N/2));%fft���ص����ݽṹ���жԳ������ֻȡһ��
        grid;
        ylim([0 0.00005]);
        xlabel('Frequency(Hz)');
        ylabel('Magnitude(dB)');
        title('After Bandpass filter');%ԭʼ�źŸ���Ҷ�任
        
        subplot(2,1,2);
        plot(f(1:N/2),yfft(1:N/2));
        grid;
        ylim([0 0.00005]);
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        title('After Bandpass filter and 100Hz notch filter');%�˲����źŵĸ���Ҷ�任
    end
    
end
end

