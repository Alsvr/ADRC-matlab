function my_nn_pid()
    %BP based PID Control
    clear all;
    close all;
    round_time = 1000;%���д���
    ts = 0.01;
    times = zeros(1,round_time);%ʱ��
    pid_con = [50,0.5,2000];%pid ����
    pid_m = zeros(1,3);%pid �˻���
    singal_in = zeros(1,round_time);%�ź�����
    bp_nn_t = bp_nn(2,4,3);%������ 2,4,3
    pid_out = zeros(1,round_time);%pid���
    singal_out = zeros(1,round_time);%�ź����
    error = zeros(1,round_time);%�ź�����
    sys=tf(1,[1,0.5,0]);  %�������ض��󴫵ݺ���
    dsys=c2d(sys,ts,'z');   %�Ѵ��ݺ�����ɢ��
    [num,den]=tfdata(dsys,'v');  %��ɢ������ȡ���ӡ���ĸ
    for k=1:1:round_time
        
        times(k)=k*ts;
        singal_in(k)=2.0;
        v = mod(k,314);
        if v<200
            singal_in(k) = sin(2*v/(pi*100));
        else
            singal_in(k) = 0.5*v^2;
        end
        if k > 3
            error(k) = singal_in(k)-singal_out(k-1);
            gradient = relu_gradient(layer_2).*layer_out_gradient;
            input_layer = [abs(error(k)),singal_in(k)];
            bp_nn_t.train(input_layer,singal_in(k-1));
            %pid_con = layer_2;
            pid_m=pid_param(error,k);
            pid_out(k) = pid_out(k-1)+pid_control(pid_con,pid_m);
            singal_out(k) = i_func_1(num,den,singal_out,pid_out,k);
       end
    end

    figure(1);
    plot(times,singal_in,'r',times,singal_out,'b');
    xlabel('time(s)');ylabel('in,out');
    %figure(1);
    %plot(times,a,'r');
    %c = neural_networks();
end

function pid_m = pid_param(error,k)
    pid_m = zeros(1,3);
    pid_m(1)=error(k)-error(k-1);
    pid_m(2)=error(k);
    pid_m(3)=error(k)-2*error(k-1)+error(k-2);
end

function out = pid_control(pid_con,pid_m)
    out = pid_con*pid_m';
end

function out=i_func_1(num,den,out_all,in_all,k)
    out = -den(2)*out_all(k-1)-den(3)*out_all(k-2)+ num(2)*in_all(k-1)+num(3)*in_all(k-2);
end
