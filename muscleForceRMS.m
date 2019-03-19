function [] = muscleForceRMS(inti,restState,data_filter)
%���㼡�����״̬�Ĵ��ھ�����ֵ�������������
%   inti=1����ʼ���������״̬��restState��¼�������״̬�ľ�����ֵ��data_filter
%�˲��������źţ�motionStateΪ�������״̬�ľ�����ֵ�����׼ֵ�Ƚ������������
 
if inti==1
    restState=windowRMS(data_filter); %��¼��Ϣ״̬�µļ����źž�����
    xlswrite('restState.xlsx',restState);
else
    motionState=windowRMS(data_filter)-restState;%�˶�״̬��ȥ��Ϣ״̬
        
    figure(2);
    subplot(211)
    plot(restState);
    axis([1 46 -6e-6 6e-6]);
    title('�������״̬');
    subplot(212)
    plot(motionState);
    axis([1 46 -6e-6 6e-6]);
    title('��������״̬');
        
    muscleForceEvaluation(motionState);%���ݼ�����������
end

end

