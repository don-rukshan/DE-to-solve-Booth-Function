function [] = booth()

clc;
clear;

lb = [-10 -10];
ub = [10 10];
prob = @boothfcn;

n = 10;                  %population size
iteration = 100;        %number of iterations
CR = 0.8;               %recombination probability
F = 0.85;               %scaling factor

f = NaN(n,1);            %fitness function values of the target vector
fu = NaN(n,1);           %fitness function values of the trial vector
u = NaN(n,2);           %trial solutions

x = init_pop(n,lb,ub);

f = evaluateFitness(n,f,x,prob);

for t=1:iteration
    for i=1:n
        
        %Mutation
        
        %choosing 3 random numbers
        candidate=[1:i-1 i+1:n];
        idx=candidate(randperm(n-1,3));      
        a=x(idx(1),:);
        b=x(idx(2),:);
        c=x(idx(3),:);
        
        v = a+F*(b-c);      %generating donor vectors
        
        %Crossover
        Irand = randi(2,1);     %integer random number between (1, Dimension)
        
        %generating trial vectors
        for j=1:2
            if(rand <= CR || Irand == j)
                u(i,j) = v(j);
            else
                u(i,j) = x(i,j);
            end
        end
    end   
    
    %Selection
    for j=1:n
        u(j,:)=min(ub, u(j,:));
        u(j,:)=max(lb, u(j,:));
        fu(j) = prob(u(j,:));
        if fu(j) < f(j)
            x(j,:) = u(j,:);
            f(j) = fu(j);
        end
    end      
end

[bestFitness, index] = min(f)
bestSolution=x(index,:)

%-------------------------------------------------------------------
function f = boothfcn(x)

n = size(x, 2);
assert(n == 2, 'Booth''s function is only defined on a 2D space.')
X = x(:, 1);
Y = x(:, 2);
f = (X + (2 * Y) - 7).^2 + ( (2 * X) + Y - 5).^2;


%-------------------------------------------------------------------
function x = init_pop(n,lb,ub)

x = repmat(lb, n, 1) + repmat((ub - lb), n, 1).*rand(n,2);


%-------------------------------------------------------------------
function f = evaluateFitness(n,f,x,prob)

for p = 1:n
    f(p) = prob(x(p,:));
end


