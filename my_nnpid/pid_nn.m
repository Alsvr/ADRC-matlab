classdef pid_nn<bp_nn
    properties
        %pid���
        pid_output = zeros(1,3);
    end
    
    methods
        %% ���캯��
        function obj=pid_nn(input_dim,h1_dim,output_dim)
            obj = obj@bp_nn(input_dim,h1_dim,output_dim);
        end
        %% ǰ��
        
    end
end