function [] = muscleForceEvaluation(RMS)
%���ݼ�����������
%   RMSΪ�˶�״̬�;�Ϣ״̬��������ֵ��DRMSΪ��ǰʵ�������׼ֵ��ֵ
%standardΪ��׼ֵ
DRMS=abs(RMS-standard)./standard;%���׼ֵ��ľ���ֵ���Ա�׼ֵ
k=-1;%����k��ʹ��yֵ��0��1��
y=1+k*(DRMS.^2);%�������ߣ����޸ģ���0��y��1ֵԽ�������Խ��
z=mean(y);%ȡ��ֵ

if z>0.8
    printf('good\n');
    if (z<=0.8)&&(z>0.6)
        printf('okay\n');
    else
        printf('bad\n');
    end
end
end

