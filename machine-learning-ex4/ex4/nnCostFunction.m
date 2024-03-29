function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)

%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);


% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));


% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m

Xnew = [ ones(m,1) , X];

Z2 = Xnew * Theta1';
A2 = [ ones( size(Z2,1) ,1) , sigmoid(Z2) ];

Z3 = A2 * Theta2';
A3 = sigmoid(Z3);

f_sum = zeros(num_labels,1);
y_new = zeros(length(y),1);

for i=1:num_labels,
    % Transform y
    y_new = y==i ;
    f_sum(i) = f_sum(i) - log(A3(:,i))' * y_new -  (1-y_new)' * log(1-A3(:,i));
end;

cols1 = size(Theta1,2);
cols2 = size(Theta2,2);

reg_term = sum(sum( Theta1(:,2:cols1).^ 2 )) + sum( sum( Theta2(:,2:cols2 ).^ 2 )) ;
reg_term =  reg_term * lambda * (1/ (2*m) );

J = (1/m) * sum(f_sum) + reg_term;

%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.


% This shud be out of the loop
D1 = zeros(size(Theta1));
D2 = zeros(size(Theta2));


for i=1:m,
    data = Xnew(i,:); %put i
    % size(data)

    % Forward pass
    z2 = data * Theta1';
    a2 = [ ones( size(z2,1) ,1) , sigmoid(z2) ];

    z3 = a2 * Theta2';
    a3 = sigmoid(z3);

    y_temp = zeros(num_labels,1);
    y_temp (y(i),:) = 1;       %Put i


    %Backward pass
    delta3 = a3' - y_temp; 

    gprime2 = a2 .* (1 - a2);
    delta2 = Theta2' * delta3 .* gprime2';
    delta2 = delta2(2:end);

    D1 = D1 + delta2 * data; % a1 =data
    D2 = D2 + delta3 * a2;

end;

%OUTSIDE THE LOOP
Theta1_grad = (1/m) * D1;
Theta2_grad = (1/m) * D2;

% size(data)
% size(D1)
% size(D2)
% size(a2)
% size(z2)
% size(a3)
% size(z3)
% size(delta2)


%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%



Theta1_grad(:,2:end) +=   (lambda/m) *  Theta1(:,2:end);
Theta2_grad(:,2:end) +=  (lambda/m) * Theta2(:,2:end);










% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
