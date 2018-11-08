clear;

load("Log 14-Nov-2017 18:17:59.mat");
%quiver(x,y,u,v)

% Get force data
%u = data.floor.img_dir_x(65:68,7:27);
%v = data.floor.img_dir_y(65:68,7:27);
u = data.floor.img_dir_x(:,:);
v = data.floor.img_dir_y(:,:);

% Get size of matrix
[h, w] = size(u);

% Reshape matrix
u = reshape(u,[w*h,1]);
v = reshape(v,[w*h,1]);

% Initialize position vectors
x = zeros(w*h,1);
y = zeros(w*h,1);

counter = 0;
for i = 1:h
    for j = 1:w
        counter = counter +1;
        
        [counter i j]
        x(counter) = i;
        y(counter) = j;
        %[(i-1)*h+j j]
    end
end

quiver(x,y,u,v);
