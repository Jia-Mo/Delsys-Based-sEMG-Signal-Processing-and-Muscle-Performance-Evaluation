function [] = fatigue(MPF,RMS)
%�жϼ���ƣ�ͣ�MPFֵ�½���RMSֵ�������жϼ���ƣ��
%  MPF��¼����ͨ����ǰ���ڵ�ƽ������Ƶ�ʣ�RMS��¼����ͨ����ǰ���ڵľ�������
%ch_MPF��¼����ͨ�����д��ڵ�MPFֵ��ch_RMS��¼����ͨ�����д��ڵ�RMSֵ
global ch_MPF;
global ch_RMS;
global ch;

for i=1:length(ch)
    ch_MPF=[ch_MPF MPF];
    ch_RMS=[ch_RMS RMS];
    
    m=trend(ch_MPF(i,:));
    n=trend(ch_RMS(i,:));
    if (m==-1)&&(n==1)
        printf('Muscle is fatugued at %s\n',datastr(now,13));
        ch_MPF=[];
        ch_RMS=[];%�ﵽƣ�͵����������
    end
end

end

