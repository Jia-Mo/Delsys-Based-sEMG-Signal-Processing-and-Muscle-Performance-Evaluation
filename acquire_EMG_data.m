function acquire_EMG_data

clear
close all force

% HOST_IP=input('Please enter ip of the computer:');%�������IP
HOST_IP='101.6.56.58';
global ch;
% ch=input('Enter the chanel you use:');
ch=2;
global plotHandles;%���߾��

%�жϼ���ƣ�͵ı���
global ch_MPF;%�洢����ͨ��ƽ������Ƶ������
global ch_RMS;%�洢����ͨ������������
ch_MPF=[];
ch_RMS=[];

%�����������ı���
global restState;
global inti;%�ж��Ƿ��ʼ��,��Ϊ1����Ҫ��ʼ����Ϊ�κ���������ֱ�Ӷ�ȡ�ļ��м�¼�ļ������״̬����
inti=0;
if inti==1
    restState=[];
else
    restState=xlsread('restState.xlsx','A:A');%��ȡ��Ϣ״̬����
end

interfaceObjectEMG = tcpip(HOST_IP,50041);%����EMGtcpip����
interfaceObjectEMG.InputBufferSize = 6400;%����������

commObject = tcpip(HOST_IP,50040);%��������ӿ�tcpip����

t = timer('Period', 0.5, 'ExecutionMode', 'fixedSpacing', 'TimerFcn', {@updatePlots,plotHandles});%��ʱ����ÿ0.5�����ͼƬ

global data_arrayEMG;
data_arrayEMG=[];%�洢EMG����
global rateAdjustedEmgBytesToRead;%������ȡEMGbytes�ٶȵı���

%����ͼƬ��ʾ
figureHandles=zeros(length(ch),1);
plotHandles=zeros(length(ch),2);
axesHandles=zeros(length(ch),2);

for i=1:length(ch)
    figureHandles(i)=figure('Name',['Sensor' num2str(ch(i))],'Numbertitle',...
        'off');
    
    axesHandles(i,1)=subplot(2,1,1);
    plotHandles(i,1)=plot(axesHandles(i,1),0,'b','LineWidth',1);
    set(axesHandles(i,1),'XGrid','on','YGrid','on','XLimMode', 'manual','YLimMode', 'manual');
    set(axesHandles(i,1),'XLim', [0 500],'YLim', [-.00005 .00005]); 
    title('original signal');
    
    axesHandles(i,2)=subplot(2,1,2);
    plotHandles(i,2)=plot(axesHandles(i,2),0,'b','LineWidth',1);
    set(axesHandles(i,2),'XGrid','on','YGrid','on','XLimMode', 'manual','YLimMode', 'manual');
    set(axesHandles(i,2),'XLim', [0 500],'YLim', [-.00005 .00005]);

    title('filtered signal');
end

fopen(commObject);%������ӿ�

pause(1);%��ͣ1��
fread(commObject,commObject.BytesAvailable);%��ȡȫ������
fprintf(commObject, sprintf(['RATE 2000\r\n\r']));%д��str'Rate 2000    '
pause(1);%��ͣ1��
fread(commObject,commObject.BytesAvailable);%��ȡȫ������
fprintf(commObject, sprintf(['RATE?\r\n\r']));%д��str'Rate?     '
pause(1);%��ͣ1��
data = fread(commObject,commObject.BytesAvailable);%��ȡȫ�����data

emgRate = strtrim(char(data'));%��dateת��Ϊ�ַ����鲢ɾ��ǰ����β��հ״洢��emgRate
if(strcmp(emgRate, '1925.926'))%�Ƚ�emgRate��'1925.926'
    rateAdjustedEmgBytesToRead=1664;
else 
    rateAdjustedEmgBytesToRead=1728;
end%���ö�ȡ�ٶ�1664

 bytesToReadEMG = rateAdjustedEmgBytesToRead;
 interfaceObjectEMG.BytesAvailableFcn = {@localReadAndPlotMultiplexedEMG,interfaceObjectEMG};
 interfaceObjectEMG.BytesAvailableFcnMode = 'byte';
 interfaceObjectEMG.BytesAvailableFcnCount = bytesToReadEMG;
 %���ö�ȡ������bytesToReadEMG�����ڵ����ٶȣ�1664���ֽ��ڻ�����ʱ���Զ��ص�����localReadAndPlotMultiplexedEMG
 
 drawnow
 start(t);
 
 try
    fopen(interfaceObjectEMG);%�򿪶���
catch
%     localCloseFigure(t);
    delete(figureHandles);
    error('CONNECTION ERROR: Please start the Delsys Trigno Control Application and try again');
 end

 fprintf(commObject, sprintf(['START\r\n\r']));%д��'START    '����
end


function localReadAndPlotMultiplexedEMG(interfaceObjectEMG,~, ~)
global rateAdjustedEmgBytesToRead;
% global counter;
% global ch;

bytesReady = interfaceObjectEMG.BytesAvailable;
bytesReady = bytesReady - mod(bytesReady, rateAdjustedEmgBytesToRead);%%1664
%ȡbyteReady��������rateAdjustEmgBytesToRead�Ĳ��֣���n1664
if (bytesReady == 0)
    return
end%bytesReady��������rateAdjustEmgBytesToRead�򷵻ص��ú����Ĳ���

global data_arrayEMG
data = cast(fread(interfaceObjectEMG,bytesReady), 'uint8');%����ȡ�����ֽ�ת��Ϊunit8�������ͣ���Ϊdata
data = typecast(data, 'single');%��dateת��Ϊsingle������


if(size(data_arrayEMG, 1) < rateAdjustedEmgBytesToRead*19)%date_arrayEMGԪ�ظ�����rateAdjustedEmgBytesToRead1664*19�Ƚ�
    data_arrayEMG = [data_arrayEMG; data];%date�ӵ�date_arrayEMG�ĺ���
else
    data_arrayEMG = [data_arrayEMG(size(data,1) + 1:size(data_arrayEMG, 1));data];%��data����data_arrrayEMG��ǰ�棬����ǰ������������
end

end


function updatePlots(obj, Event,  tmp)
global data_arrayEMG;
global plotHandles;
global ch;
global ch_MPF;
global ch_RMS;
global restState;
global inti;

MPF=zeros(length(ch),1);
RMS=zeros(length(ch),1);


for i = 1:length(ch)
    data_ch = data_arrayEMG(ch(i):16:8000);%��data_arrayEMG������ȡ��һ��ͨ��������
    data_filter=process(data_ch,ch(i));%�������˲�
    set(plotHandles(i,1),'YData',data_ch);
    set(plotHandles(i,2),'YData',data_filter);
    drawnow
    
    %��������
    muscleForceRMS(inti,restState,data_filter);
     
    %��ǰ���ڵ�MPF��RMS
    MPF(i)=meanPowerFrequency(data_filter);
    RMS(i)=rootMeanSquare(data_filter); 
    
end

%�жϼ����Ƿ�ƣ��
fatigue(MPF,RMS);

    
end 

% function localCloseFigure(t)
% % interfaceObject1, commObject,
% 
% %% 
% % Clean up the network objects
% % if isvalid(interfaceObject1)
%     fclose(interfaceObject1);
%     delete(interfaceObject1);
%     clear interfaceObject1;
% % end
% 
% % if isvalid(t)
%    stop(t);
%    delete(t);
% % end
% 
% % if isvalid(commObject)
%     fclose(commObject);
%     delete(commObject);
%     clear commObject;
% % end
% 
% %% 
% % Close the figure window
% % delete(figureHandle);
% end
