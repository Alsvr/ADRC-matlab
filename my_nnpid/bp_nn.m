classdef bp_nn< handle
    properties
        %ѧϰ��
        learning_rate =  0.1;
        %�����ߴ�
        input_dim = 2;
        %������1�ߴ�
        h1_dim = 4;
        %������2�ߴ�
        %h2_dim = 4;
        %�����ߴ�
        output_dim = 3;
        w_i;
        b_i;
        w_o;
        b_o;
        output;
        h_layer_1;
    end
    methods
        %% ���캯��
        function obj = bp_nn(input_dim,h1_dim,output_dim)
            obj.input_dim = input_dim;
            obj.h1_dim = h1_dim;
            obj.output_dim = output_dim;
            obj.w_i = rands(input_dim,h1_dim);
            obj.b_i = rands(1,h1_dim);
            obj.w_o = rands(h1_dim,output_dim);
            obj.b_o = rands(1,output_dim);
            obj.h_layer_1 = zeros(1,h1_dim);
        end
        %% ѵ��
        function train(obj,input,eval)
                obj.h_layer_1 = obj.neural_networks_forward(input,obj.w_i,obj.b_i,@obj.lrelu);
                obj.output = obj.neural_networks_forward(obj.h_layer_1,obj.w_o,obj.b_o,@obj.lrelu);
                gradient = obj.output-eval;
                [obj.w_o,obj.b_o,last_gradient] = obj.neural_networks_back(obj.learning_rate,obj.h_layer_1,obj.output,obj.w_o,obj.b_o,gradient,@bp_nn.lrelu_gradient);
                [obj.w_i,obj.b_i,~] = obj.neural_networks_back(obj.learning_rate,input,obj.h_layer_1,obj.w_i,obj.b_i,last_gradient,@obj.lrelu_gradient);
                gradient
        end
    end
    methods(Static)
        %% ǰ�򴫲�
        function out = neural_networks_forward(input,weights,bias,active_func)
            out_unactive = input*weights+bias;
            out = active_func(out_unactive);
        end
        %% ������
        function [weights_new,bias_new,last_gradient] = neural_networks_back(learning_rate,input_layer,out,weights,bias,gradient,active_gradient_func)
            %�������
            gradient_new = active_gradient_func(out).*gradient;
            %����ƫ��
            bias_new = bias - learning_rate.*gradient_new;
            %weights �ĳߴ� input*output
            [w_h,w_w] = size(weights);
            
            %����ƫ��
            x_t = repmat(input_layer',1,w_w);
            gradient_t = repmat(gradient_new,w_h,1);
            weights_new = weights - learning_rate*gradient_t.*x_t;
            %����һ���ݶ�
            last_gradient = gradient_t.*weights;
            last_gradient = sum(last_gradient,2)';
        end
        %% Leaky relu
        function output = lrelu(x)
            output = x;
            for k=1:1:length(output)
                if output(k) < 0
                    output(k)=0.1*output(k);
                end
            end
        end
        %% Leaky relu gradient
        function gradient = lrelu_gradient(output)
            gradient = ones(1,length(output));
            for k=1:1:length(output)
                if output(k)<=0
                    gradient(k) = 0.1;
                end
            end
        end
        %% sigmoid
        function output = sigmoid(x)
            output =1./(1+exp(-x));
        end
        %% sigmoid gradient
        function gradient = sigmoid_gradient(output)
            gradient =output.*(1-output);
        end
    end
        
end